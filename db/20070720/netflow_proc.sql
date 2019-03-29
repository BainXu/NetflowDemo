CREATE OR REPLACE FUNCTION getHours(
    date_           DATE
)
RETURN NUMBER AS
   rs_        NUMBER(12);
BEGIN
    SELECT trunc(24*(date_ - to_date('1900-1-1 ','yyyy-mm-dd'))) INTO rs_ FROM dual;
    RETURN rs_;
END;
/* */

CREATE OR REPLACE FUNCTION getDays(
    date_           DATE
)
RETURN NUMBER AS
   rs_        NUMBER(12);
BEGIN
    SELECT trunc(trunc(date_) - to_date('1900-1-1 ','yyyy-mm-dd')) INTO rs_ FROM dual;
    RETURN rs_;
END;
/* */

CREATE OR REPLACE FUNCTION getMonths(
    date_           DATE
)
RETURN NUMBER AS
   rs_        NUMBER(12);
BEGIN
    SELECT trunc(months_between(date_ , to_date('1900-1-1 ','yyyy-mm-dd')))+1 INTO rs_ FROM dual;
    RETURN rs_;
END;
/* */

--Save netflow to database.

CREATE OR REPLACE PROCEDURE SaveNetflow (
    engineId_         NUMBER,
    targetId_         NUMBER,
    targetName_       VARCHAR2, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts_             NUMBER,
    bytes_            NUMBER,
    collectTime_      DATE
)
AS
    counter1_         NUMBER(8);
    counter2_         NUMBER(8);
    counter3_         NUMBER(8);
    pastDate_         DATE;
    pktsSum_          NUMBER(38);
    bytesSum_         NUMBER(38);
    counts_           NUMBER(8);
    time_             NUMBER(8);
BEGIN       
	SELECT count(*) INTO counter1_ FROM NFLastRecordTab WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_;
	IF counter1_ > 0 THEN
		SELECT collectTime INTO pastDate_ FROM NFLastRecordTab WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_;
	ELSE
        BEGIN
            INSERT INTO NFLastRecordTab VALUES (engineId_, targetId_, targetName_, pkts_, bytes_, collectTime_);
            INSERT INTO NFLastHourTab   VALUES (engineId_, targetId_, targetName_, pkts_, bytes_, collectTime_);
            RETURN;
        END;
	END IF;
	--Abandon data if collectTime_ < pastDate_
	IF pastDate_ < collectTime_  THEN
	BEGIN
		--Update the last record table
		UPDATE NFLastRecordTab SET pkts = pkts_, bytes = bytes_, collectTime = collectTime_
			WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_;
			
		--If step over hour, then do hour-aggregation.
		IF abs(getHours(collectTime_) - getHours(pastDate_))>0 THEN
		BEGIN
			--calculate last one hour datas.
			SELECT sum(pkts), sum(bytes) INTO pktsSum_, bytesSum_ FROM NFLastHourTab
				WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_;
			--save one hour aggregation data.
			INSERT INTO NFHourTab
				VALUES (engineId_, targetId_, targetName_, pktsSum_, bytesSum_, getHours(pastDate_));
			--add one hour aggregation data to last day table.
			INSERT INTO NFLastDayTab
				VALUES (engineId_, targetId_, targetName_, pktsSum_, bytesSum_, getHours(pastDate_));
			--delete last one hour datas
			DELETE FROM NFLastHourTab WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_;
			
			--if step over day, then do day-aggregation.
			IF trunc(pastDate_ )<trunc( collectTime_) THEN
			BEGIN
				--calculate last day datas
				SELECT count(*), sum(pkts), sum(bytes) INTO counts_, pktsSum_, bytesSum_
                	FROM NFLastDayTab WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_;
                time_ := getDays(pastDate_);
				--save one day aggregation data.
				INSERT INTO NFDayTab
					VALUES (engineId_, targetId_, targetName_, pktsSum_, bytesSum_, time_, counts_);
				--add one day aggregation data to last week table.
                INSERT INTO NFLastWeekTab
                	VALUES (engineId_, targetId_, targetName_, pktsSum_, bytesSum_, time_, counts_);
				--add one day aggregation data to last month table.
				INSERT INTO NFLastMonthTab
					VALUES (engineId_, targetId_, targetName_, pktsSum_, bytesSum_, time_, counts_);
				--delete last day history hour data after aggregation.
				DELETE FROM NFLastDayTab WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_;
				--calculate last week datas.
				SELECT sum(counts), sum(pkts), sum(bytes) INTO counts_, pktsSum_, bytesSum_
					FROM NFLastWeekTab WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_;
				--data aggregation for last week.
				time_ := trunc(getDays(pastDate_)/7);
				SELECT count(*) INTO counter2_ FROM NFWeekTab WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_ AND iweek = time_;
				IF counter2_ > 0 THEN
                	UPDATE NFWeekTab SET counts = counts_, pkts = pkts_, bytes = bytes_
                    	WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_ AND iweek = time_;
				ELSE
					INSERT INTO NFWeekTab 
						VALUES (engineId_, targetId_, targetName_, pkts_, bytes_,time_, counts_);
				END IF;

				--if step over one week, then delete last week day datas.
				IF  trunc(getdays(pastDate_)/7)<  trunc(getdays(collectTime_)/7) THEN
                	--delete last week history day datas.
                    DELETE FROM NFLastWeekTab WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_;
                END IF;
                    
				--calculate last month datas.
				SELECT sum(counts), sum(pkts), sum(bytes) INTO counts_, pktsSum_, bytesSum_
					FROM NFLastMonthTab WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_;
				--data aggregation for last month.
				time_ := getMonths(pastDate_);
				SELECT count(*) INTO counter3_ FROM NFMonthTab WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_ AND imonth = time_;
				IF counter3_ > 0 THEN
					UPDATE NFMonthTab SET counts = counts_, pkts = pkts_, bytes = bytes_
						WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_ AND imonth = time_;
				ELSE
					INSERT INTO NFMonthTab
						VALUES (engineId_, targetId_, targetName_, pkts_, bytes_,time_, counts_);
				END IF;
				
				--if step over one month, then delete last month datas.
				IF trunc(months_between(pastDate_ , collectTime_)) > 0 THEN
					--delete last month history day datas.
					DELETE FROM NFLastMonthTab WHERE engineId = engineId_ AND targetId = targetId_ AND targetName = targetName_;
				END IF;
            END;
            END IF; -- if step over days
		END;
		END IF; -- if step over hours
		
		--add data to last hour data table.
		INSERT INTO NFLastHourTab VALUES (engineId_, targetId_, targetName_, pkts_, bytes_, collectTime_);
    END;
	END IF; -- if pastDate_ < collectTime_ 
END;
/* */
