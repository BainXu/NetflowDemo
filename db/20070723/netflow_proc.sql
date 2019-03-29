CREATE OR REPLACE FUNCTION SP_GET_HOURS(
    date_           DATE
)
RETURN NUMBER AS
   rs_        NUMBER(12);
BEGIN
    SELECT trunc(24*(date_ - to_date('1900-1-1 ','yyyy-mm-dd'))) INTO rs_ FROM dual;
    RETURN rs_;
END;
/* */

CREATE OR REPLACE FUNCTION SP_GET_DAYS(
    date_           DATE
)
RETURN NUMBER AS
   rs_        NUMBER(12);
BEGIN
    SELECT trunc(trunc(date_) - to_date('1900-1-1 ','yyyy-mm-dd')) INTO rs_ FROM dual;
    RETURN rs_;
END;
/* */

CREATE OR REPLACE FUNCTION SP_GET_MONTHS(
    date_           DATE
)
RETURN NUMBER AS
   rs_        NUMBER(12);
BEGIN
    SELECT trunc(months_between(date_ , to_date('1900-1-1 ','yyyy-mm-dd')))+1 INTO rs_ FROM dual;
    RETURN rs_;
END;
/* */

CREATE OR REPLACE PROCEDURE SP_NF_SAVE (
    DEV_ID_           NUMBER,
    target_ID_        NUMBER,
    target_ID2_       NUMBER,
    targetName_       VARCHAR2, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS,CONVERSATION
    pkts_             NUMBER,
    bytes_            NUMBER,
    collectTime_      DATE,
    flag_             NUMBER --CONVERSATION flag
)
AS
BEGIN
	IF flag_ > 0 THEN
		SP_SAVE_NETFLOW_CONV(DEV_ID_,target_ID_,target_ID2_,pkts_,bytes_,collectTime_);
	ELSE
		SP_SAVE_NETFLOW(DEV_ID_,target_ID_,targetName_,pkts_,bytes_,collectTime_);
	END IF;
END;
/* */

--Save netflow to database.

CREATE OR REPLACE PROCEDURE SP_SAVE_NETFLOW (
    DEV_ID_         NUMBER,
    target_ID_         NUMBER,
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
	SELECT count(*) INTO counter1_ FROM NF_LAST_RECORD WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_;
	IF counter1_ > 0 THEN
		SELECT collectTime INTO pastDate_ FROM NF_LAST_RECORD WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_;
	ELSE
        BEGIN
            INSERT INTO NF_LAST_RECORD VALUES (DEV_ID_, target_ID_, targetName_, pkts_, bytes_, collectTime_);
            INSERT INTO NF_LAST_HOUR   VALUES (DEV_ID_, target_ID_, targetName_, pkts_, bytes_, collectTime_);
            RETURN;
        END;
	END IF;
	--Abandon data if collectTime_ < pastDate_
	IF pastDate_ < collectTime_  THEN
	BEGIN
		--Update the last record table
		UPDATE NF_LAST_RECORD SET pkts = pkts_, bytes = bytes_, collectTime = collectTime_
			WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_;
			
		--If step over hour, then do hour-aggregation.
		IF abs(SP_GET_HOURS(collectTime_) - SP_GET_HOURS(pastDate_))>0 THEN
		BEGIN
			--calculate last one hour datas.
			SELECT sum(pkts), sum(bytes) INTO pktsSum_, bytesSum_ FROM NF_LAST_HOUR
				WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_;
			--save one hour aggregation data.
			INSERT INTO NF_HOUR
				VALUES (DEV_ID_, target_ID_, targetName_, pktsSum_, bytesSum_, SP_GET_HOURS(pastDate_));
			--add one hour aggregation data to last day table.
			INSERT INTO NF_LAST_DAY
				VALUES (DEV_ID_, target_ID_, targetName_, pktsSum_, bytesSum_, SP_GET_HOURS(pastDate_));
			--delete last one hour datas
			DELETE FROM NF_LAST_HOUR WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_;
			
			--if step over day, then do day-aggregation.
			IF trunc(pastDate_ )<trunc( collectTime_) THEN
			BEGIN
				--calculate last day datas
				SELECT count(*), sum(pkts), sum(bytes) INTO counts_, pktsSum_, bytesSum_
                	FROM NF_LAST_DAY WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_;
                time_ := SP_GET_DAYS(pastDate_);
				--save one day aggregation data.
				INSERT INTO NF_DAY
					VALUES (DEV_ID_, target_ID_, targetName_, pktsSum_, bytesSum_, time_, counts_);
				--add one day aggregation data to last week table.
                INSERT INTO NF_LAST_WEEK
                	VALUES (DEV_ID_, target_ID_, targetName_, pktsSum_, bytesSum_, time_, counts_);
				--add one day aggregation data to last month table.
				INSERT INTO NF_LAST_MONTH
					VALUES (DEV_ID_, target_ID_, targetName_, pktsSum_, bytesSum_, time_, counts_);
				--delete last day history hour data after aggregation.
				DELETE FROM NF_LAST_DAY WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_;
				--calculate last week datas.
				SELECT sum(counts), sum(pkts), sum(bytes) INTO counts_, pktsSum_, bytesSum_
					FROM NF_LAST_WEEK WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_;
				--data aggregation for last week.
				time_ := trunc(SP_GET_DAYS(pastDate_)/7);
				SELECT count(*) INTO counter2_ FROM NF_WEEK WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_ AND iweek = time_;
				IF counter2_ > 0 THEN
                	UPDATE NF_WEEK SET counts = counts_, pkts = pkts_, bytes = bytes_
                    	WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_ AND iweek = time_;
				ELSE
					INSERT INTO NF_WEEK 
						VALUES (DEV_ID_, target_ID_, targetName_, pkts_, bytes_,time_, counts_);
				END IF;

				--if step over one week, then delete last week day datas.
				IF  trunc(SP_GET_DAYS(pastDate_)/7)<  trunc(SP_GET_DAYS(collectTime_)/7) THEN
                	--delete last week history day datas.
                    DELETE FROM NF_LAST_WEEK WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_;
                END IF;
                    
				--calculate last month datas.
				SELECT sum(counts), sum(pkts), sum(bytes) INTO counts_, pktsSum_, bytesSum_
					FROM NF_LAST_MONTH WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_;
				--data aggregation for last month.
				time_ := SP_GET_MONTHS(pastDate_);
				SELECT count(*) INTO counter3_ FROM NF_MONTH WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_ AND imonth = time_;
				IF counter3_ > 0 THEN
					UPDATE NF_MONTH SET counts = counts_, pkts = pkts_, bytes = bytes_
						WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_ AND imonth = time_;
				ELSE
					INSERT INTO NF_MONTH
						VALUES (DEV_ID_, target_ID_, targetName_, pkts_, bytes_,time_, counts_);
				END IF;
				
				--if step over one month, then delete last month datas.
				IF trunc(months_between(pastDate_ , collectTime_)) > 0 THEN
					--delete last month history day datas.
					DELETE FROM NF_LAST_MONTH WHERE DEV_ID = DEV_ID_ AND target_ID = target_ID_ AND targetName = targetName_;
				END IF;
            END;
            END IF; -- if step over days
		END;
		END IF; -- if step over hours
		
		--add data to last hour data table.
		INSERT INTO NF_LAST_HOUR VALUES (DEV_ID_, target_ID_, targetName_, pkts_, bytes_, collectTime_);
    END;
	END IF; -- if pastDate_ < collectTime_ 
END;
/* */
