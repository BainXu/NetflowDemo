--------------------------------------------------------------------------------
--Netflow talker last record table
CREATE TABLE NFTalkerLastRecordTab (
    engineAddr      NUMBER(12)        NOT NULL,
    srcAddr         NUMBER(12)        NOT NULL,
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    collectTime     DATE              NOT NULL,
    CONSTRAINT pk_NFTalkerLastRecordTab PRIMARY KEY (engineAddr, srcAddr)
)/**/
CREATE UNIQUE INDEX NFTalkerLastRecordInd ON NFTalkerLastRecordTab (engineAddr, srcAddr, bytes DESC)/**/

--Last hour datas for each talker
CREATE TABLE NFTalkerLastHourTab (
    engineAddr      NUMBER(12)        NOT NULL,
    srcAddr         NUMBER(12)        NOT NULL,
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    collectTime     DATE              NOT NULL,
    CONSTRAINT pk_NFTalkerLastHourTab PRIMARY KEY (engineAddr, srcAddr, collectTime)
)/**/
CREATE INDEX NFTalkerLastHourTabInd ON NFTalkerLastHourTab (engineAddr, srcAddr)/**/

--All hour-data for each talker
CREATE TABLE NFTalkerHourTab (
    engineAddr      NUMBER(12)        NOT NULL,
    srcAddr         NUMBER(12)        NOT NULL,
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    hour            NUMBER(10)        NOT NULL,
    CONSTRAINT pk_NFTalkerHourTab PRIMARY KEY (engineAddr, srcAddr, hour)
)/**/
CREATE UNIQUE INDEX NFTalkerHourTabInd ON NFTalkerHourTab (engineAddr, srcAddr, hour ASC, bytes DESC)/**/

--Last day hour-data for each talker (maximum 24 records for each talker)
CREATE TABLE NFTalkerLastDayTab (
    engineAddr      NUMBER(12)        NOT NULL,
    srcAddr         NUMBER(12)        NOT NULL,
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    hour            NUMBER(10)        NOT NULL,
    CONSTRAINT pk_NFTalkerLastDayTab PRIMARY KEY (engineAddr, srcAddr, hour)
)/**/
CREATE INDEX NFTalkerLastDayTabInd ON NFTalkerLastDayTab (engineAddr, srcAddr)/**/

--All day-data for each talker
CREATE TABLE NFTalkerDayTab (
    engineAddr      NUMBER(12)        NOT NULL,
    srcAddr         NUMBER(12)        NOT NULL,
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    day             NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFTalkerDayTab PRIMARY KEY (engineAddr, srcAddr, day)
)/**/
CREATE UNIQUE INDEX NFTalkerDayTabInd ON NFTalkerDayTab (engineAddr, srcAddr, day ASC, bytes DESC)/**/

--Last week day-data for each talker (maximum 7 rows for each talker)
CREATE TABLE NFTalkerLastWeekTab (
    engineAddr      NUMBER(12)        NOT NULL,
    srcAddr         NUMBER(12)        NOT NULL,
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    day             NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFTalkerLastWeekTab PRIMARY KEY (engineAddr, srcAddr, day)
)/**/
CREATE INDEX NFTalkerLastWeekTabInd ON NFTalkerLastWeekTab (engineAddr, srcAddr)/**/

--All week-data for each talker
CREATE TABLE NFTalkerWeekTab (
    engineAddr      NUMBER(12)        NOT NULL,
    srcAddr         NUMBER(12)        NOT NULL,
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    week            NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFTalkerWeekTab PRIMARY KEY (engineAddr, srcAddr, week)
)/**/
CREATE UNIQUE INDEX NFTalkerWeekTabInd ON NFTalkerWeekTab (engineAddr, srcAddr, week ASC, bytes DESC)/**/

--Last month day-data for each talker (maximum 31 rows for each talker)
CREATE TABLE NFTalkerLastMonthTab (
    engineAddr      NUMBER(12)        NOT NULL,
    srcAddr         NUMBER(12)        NOT NULL,
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    day             NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFTalkerLastMonthTab PRIMARY KEY (engineAddr, srcAddr, day)
)/**/
CREATE INDEX NFTalkerLastMonthTabInd ON NFTalkerLastMonthTab (engineAddr, srcAddr)/**/

--All month-data for each talker
CREATE TABLE NFTalkerMonthTab (
    engineAddr      NUMBER(12)        NOT NULL,
    srcAddr         NUMBER(12)        NOT NULL,
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    month           NUMBER(6)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFTalkerMonthTab PRIMARY KEY (engineAddr, srcAddr, month)
)/**/
CREATE UNIQUE INDEX NFTalkerMonthTabInd ON NFTalkerMonthTab (engineAddr, srcAddr, month ASC, bytes DESC)/**/

CREATE OR REPLACE FUNCTION getHours(
    date_           DATE
)
RETURN NUMBER AS
   rs_        NUMBER(12);
BEGIN
    SELECT trunc(24*(date_ - to_date('1900-1-1 ','yyyy-mm-dd'))) INTO rs_ from dual;
    return rs_;
END;
/**/

CREATE OR REPLACE FUNCTION getDays(
    date_           DATE
)
RETURN NUMBER AS
   rs_        NUMBER(12);
BEGIN
    SELECT trunc(trunc(date_) - to_date('1900-1-1 ','yyyy-mm-dd')) INTO rs_ from dual;
    return rs_;
END;
/**/

CREATE OR REPLACE FUNCTION getMonths(
    date_           DATE
)
RETURN NUMBER AS
   rs_        NUMBER(12);
BEGIN
    SELECT trunc(months_between(date_ , to_date('1900-1-1 ','yyyy-mm-dd')))+1 INTO rs_ from dual;
    return rs_;
END;
/**/