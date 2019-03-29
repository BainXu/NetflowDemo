--Save conversation netflow to database.

CREATE OR REPLACE PROCEDURE SP_SAVE_NETFLOW_CONV (
    DEV_ID_           NUMBER,
    addr1_            NUMBER,
    addr2_            NUMBER,
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
	SELECT count(*) INTO counter1_ FROM NF_CONV_LAST_RECORD 
		WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_));
	IF counter1_ > 0 THEN
		SELECT collectTime INTO pastDate_ FROM NF_CONV_LAST_RECORD
			WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_));
	ELSE
        BEGIN
            INSERT INTO NF_CONV_LAST_RECORD VALUES (DEV_ID_, addr1_, addr2_, pkts_, bytes_, collectTime_);
            INSERT INTO NF_CONV_LAST_HOUR   VALUES (DEV_ID_, addr1_, addr2_, pkts_, bytes_, collectTime_);
            RETURN;
        END;
	END IF;
	--Abandon data if collectTime_ < pastDate_
	IF pastDate_ < collectTime_  THEN
	BEGIN
		--Update the last record table
		UPDATE NF_CONV_LAST_RECORD SET pkts = pkts_, bytes = bytes_, collectTime = collectTime_
			WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_));
			
		--If step over hour, then do hour-aggregation.
		IF abs(SP_GET_HOURS(collectTime_) - SP_GET_HOURS(pastDate_))>0 THEN
		BEGIN
			--calculate last one hour datas.
			SELECT sum(pkts), sum(bytes) INTO pktsSum_, bytesSum_ FROM NF_CONV_LAST_HOUR
				WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_));
			--save one hour aggregation data.
			INSERT INTO NF_CONV_HOUR
				VALUES (DEV_ID_, addr1_, addr2_, pktsSum_, bytesSum_, SP_GET_HOURS(pastDate_));
			--add one hour aggregation data to last day table.
			INSERT INTO NF_CONV_LAST_DAY
				VALUES (DEV_ID_, addr1_, addr2_, pktsSum_, bytesSum_, SP_GET_HOURS(pastDate_));
			--delete last one hour datas
			DELETE FROM NF_CONV_LAST_HOUR 
				WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_));
			
			--if step over day, then do day-aggregation.
			IF trunc(pastDate_ )<trunc( collectTime_) THEN
			BEGIN
				--calculate last day datas
				SELECT count(*), sum(pkts), sum(bytes) INTO counts_, pktsSum_, bytesSum_
                	FROM NF_CONV_LAST_DAY 
                	WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_));
                time_ := SP_GET_DAYS(pastDate_);
				--save one day aggregation data.
				INSERT INTO NF_CONV_DAY
					VALUES (DEV_ID_, addr1_, addr2_, pktsSum_, bytesSum_, time_, counts_);
				--add one day aggregation data to last week table.
                INSERT INTO NF_CONV_LAST_WEEK
                	VALUES (DEV_ID_, addr1_, addr2_, pktsSum_, bytesSum_, time_, counts_);
				--add one day aggregation data to last month table.
				INSERT INTO NF_CONV_LAST_MONTH
					VALUES (DEV_ID_, addr1_, addr2_, pktsSum_, bytesSum_, time_, counts_);
				--delete last day history hour data after aggregation.
				DELETE FROM NF_CONV_LAST_DAY 
					WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_));
				--calculate last week datas.
				SELECT sum(counts), sum(pkts), sum(bytes) INTO counts_, pktsSum_, bytesSum_
					FROM NF_CONV_LAST_WEEK 
					WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_));
				--data aggregation for last week.
				time_ := trunc(SP_GET_DAYS(pastDate_)/7);
				SELECT count(*) INTO counter2_ FROM NF_CONV_WEEK 
					WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_)) AND iweek = time_;
				IF counter2_ > 0 THEN
                	UPDATE NF_CONV_WEEK SET counts = counts_, pkts = pkts_, bytes = bytes_
                    	WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_)) AND iweek = time_;
				ELSE
					INSERT INTO NF_CONV_WEEK
						VALUES (DEV_ID_, addr1_, addr2_, pkts_, bytes_,time_, counts_);
				END IF;

				--if step over one week, then delete last week day datas.
				IF  trunc(SP_GET_DAYS(pastDate_)/7)<  trunc(SP_GET_DAYS(collectTime_)/7) THEN
                	--delete last week history day datas.
                    DELETE FROM NF_CONV_LAST_WEEK 
                    WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_));
                END IF;
                    
				--calculate last month datas.
				SELECT sum(counts), sum(pkts), sum(bytes) INTO counts_, pktsSum_, bytesSum_
					FROM NF_CONV_LAST_MONTH 
					WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_));
				--data aggregation for last month.
				time_ := SP_GET_MONTHS(pastDate_);
				SELECT count(*) INTO counter3_ FROM NF_CONV_MONTH 
					WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_)) AND imonth = time_;
				IF counter3_ > 0 THEN
					UPDATE NF_CONV_MONTH SET counts = counts_, pkts = pkts_, bytes = bytes_
						WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_)) AND imonth = time_;
				ELSE
					INSERT INTO NF_CONV_MONTH
						VALUES (DEV_ID_, addr1_, addr2_, pkts_, bytes_,time_, counts_);
				END IF;
				
				--if step over one month, then delete last month datas.
				IF trunc(months_between(pastDate_ , collectTime_)) > 0 THEN
					--delete last month history day datas.
					DELETE FROM NF_CONV_LAST_MONTH 
					WHERE DEV_ID = DEV_ID_ AND ((addr1 = addr1_ AND addr2 = addr2_) OR (addr1 = addr2_ AND addr2 = addr1_));
				END IF;
            END;
            END IF; -- if step over days
		END;
		END IF; -- if step over hours
		
		--add data to last hour data table.
		INSERT INTO NF_CONV_LAST_HOUR VALUES (DEV_ID_, addr1_, addr2_, pkts_, bytes_, collectTime_);
    END;
	END IF; -- if pastDate_ < collectTime_ 
END;
/* */