--Save netflow to database.

CREATE OR REPLACE PROCEDURE SaveNetflow (
    engineAddr_       NUMBER,
    srcAddr_          NUMBER,
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
	SELECT count(*) INTO counter1_ FROM NFTalkerLastRecordTab WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_;
	IF counter1_ > 0 THEN
		SELECT collectTime INTO pastDate_ FROM NFTalkerLastRecordTab WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_;
	ELSE
        BEGIN
            INSERT INTO NFTalkerLastRecordTab VALUES (engineAddr_, srcAddr_, pkts_, bytes_, collectTime_);
            INSERT INTO NFTalkerLastHourTab   VALUES (engineAddr_, srcAddr_, pkts_, bytes_, collectTime_);
            RETURN;
        END;
	END IF;
	--Abandon data if collectTime_ < pastDate_
	IF pastDate_ < collectTime_  THEN
	BEGIN
		--Update the last record table
		UPDATE NFTalkerLastRecordTab SET pkts = pkts_, bytes = bytes_, collectTime = collectTime_
			WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_;
			
		--If step over hour, then do hour-aggregation.
		IF abs(getHours(collectTime_) - getHours(pastDate_))>0 THEN
		BEGIN
			--calculate last one hour datas.
			SELECT SUM(pkts), SUM(bytes) INTO pktsSum_, bytesSum_ FROM NFTalkerLastHourTab
				WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_;
			--save one hour aggregation data.
			INSERT INTO NFTalkerHourTab
				VALUES (engineAddr_, srcAddr_, pktsSum_, bytesSum_, getHours(pastDate_));
			--add one hour aggregation data to last day table.
			INSERT INTO NFTalkerLastDayTab
				VALUES (engineAddr_, srcAddr_, pktsSum_, bytesSum_, getHours(pastDate_));
			--delete last one hour datas
			DELETE FROM NFTalkerLastHourTab WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_;
			
			--if step over day, then do day-aggregation.
			IF trunc(pastDate_ )<trunc( collectTime_) THEN
			BEGIN
				--calculate last day datas
				SELECT count(*), sum(pkts), sum(bytes) INTO counts_, pktsSum_, bytesSum_
                	FROM NFTalkerLastDayTab WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_;
                time_ := getDays(pastDate_);
				--save one day aggregation data.
				INSERT INTO NFTalkerDayTab
					VALUES (engineAddr_, srcAddr_, pktsSum_, bytesSum_, time_, counts_);
				--add one day aggregation data to last week table.
                INSERT INTO NFTalkerLastWeekTab
                	VALUES (engineAddr_, srcAddr_, pktsSum_, bytesSum_, time_, counts_);
				--add one day aggregation data to last month table.
				INSERT INTO NFTalkerLastMonthTab
					VALUES (engineAddr_, srcAddr_, pktsSum_, bytesSum_, time_, counts_);
				--delete last day history hour data after aggregation.
				DELETE FROM NFTalkerLastDayTab WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_;
				--calculate last week datas.
				SELECT sum(counts), sum(pkts), sum(bytes) INTO counts_, pktsSum_, bytesSum_
					FROM NFTalkerLastWeekTab WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_;
				--data aggregation for last week.
				time_ := trunc(getDays(pastDate_)/7);
				SELECT count(*) INTO counter2_ FROM NFTalkerWeekTab WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_ AND week = time_;
				IF counter2_ > 0 THEN
                	UPDATE NFTalkerWeekTab SET counts = counts_, pkts = pkts_, bytes = bytes_
                    	WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_ AND week = time_;
				ELSE
					INSERT INTO NFTalkerWeekTab 
						VALUES (engineAddr_, srcAddr_, pkts_, bytes_,time_, counts_);
				END IF;

				--if step over one week, then delete last week day datas.
				IF  trunc(getdays(pastDate_)/7)<  trunc(getdays(collectTime_)/7) THEN
                	--delete last week history day datas.
                    DELETE FROM NFTalkerLastWeekTab WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_;
                END IF;
                    
				--calculate last month datas.
				SELECT sum(counts), sum(pkts), sum(bytes) INTO counts_, pktsSum_, bytesSum_
					FROM NFTalkerLastMonthTab WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_;
				--data aggregation for last month.
				time_ := getMonths(pastDate_);
				SELECT count(*) INTO counter3_ FROM NFTalkerMonthTab WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_ AND month = time_;
				IF counter3_ > 0 THEN
					UPDATE NFTalkerMonthTab SET counts = counts_, pkts = pkts_, bytes = bytes_
						WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_ AND month = time_;
				ELSE
					INSERT INTO NFTalkerMonthTab
						VALUES (engineAddr_, srcAddr_, pkts_, bytes_,time_, counts_);
				END IF;
				
				--if step over one month, then delete last month datas.
				IF trunc(months_between(pastDate_ , collectTime_)) > 0 THEN
					--delete last month history day datas.
					DELETE FROM NFTalkerLastMonthTab WHERE engineAddr = engineAddr_ AND srcAddr = srcAddr_;
				END IF;
            END;
            END IF; -- if step over days
		END;
		END IF; -- if step over hours
		
		--add data to last hour data table.
		INSERT INTO NFTalkerLastHourTab VALUES (engineAddr_, srcAddr_, pkts_, bytes_, collectTime_);
    END;
	END IF; -- if pastDate_ < collectTime_ 
END;
/**/
