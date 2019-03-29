--------------------------------------------------------------------------------
--Netflow lastest record table
CREATE TABLE NFLastRecordTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    collectTime     DATE              NOT NULL,
    CONSTRAINT pk_NFLastRecordTab PRIMARY KEY (engineId,targetId,targetName)
)/**/
CREATE UNIQUE INDEX NFLastRecordInd ON NFLastRecordTab (engineId, targetId, targetName, bytes DESC)/**/

--Last hour datas
CREATE TABLE NFLastHourTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    collectTime     DATE              NOT NULL,
    CONSTRAINT pk_NFLastHourTab PRIMARY KEY (engineId, targetId, targetName, collectTime)
)/**/
CREATE INDEX NFLastHourTabInd ON NFLastHourTab (engineId, targetId, targetName)/**/

--All hour-data
CREATE TABLE NFHourTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    hour            NUMBER(10)        NOT NULL,
    CONSTRAINT pk_NFHourTab PRIMARY KEY (engineId, targetId, targetName, hour)
)/**/
CREATE UNIQUE INDEX NFHourTabInd ON NFHourTab (engineId, targetId, targetName, hour ASC, bytes DESC)/**/

--Last day hour-data (maximum 24 records for each target)
CREATE TABLE NFLastDayTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    hour            NUMBER(10)        NOT NULL,
    CONSTRAINT pk_NFLastDayTab PRIMARY KEY (engineId, targetId, targetName, hour)
)/**/
CREATE INDEX NFLastDayTabInd ON NFLastDayTab (engineId, targetId, targetName)/**/

--All day-data
CREATE TABLE NFDayTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    day             NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFDayTab PRIMARY KEY (engineId, targetId, targetName, day)
)/**/
CREATE UNIQUE INDEX NFDayTabInd ON NFDayTab (engineId, targetId, targetName, day ASC, bytes DESC)/**/

--Last week day-data (maximum 7 rows for each target)
CREATE TABLE NFLastWeekTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    day             NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFLastWeekTab PRIMARY KEY (engineId, targetId, targetName, day)
)/**/
CREATE INDEX NFLastWeekTabInd ON NFLastWeekTab (engineId, targetId, targetName)/**/

--All week-data
CREATE TABLE NFWeekTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    week            NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFWeekTab PRIMARY KEY (engineId, targetId, targetName, week)
)/**/
CREATE UNIQUE INDEX NFWeekTabInd ON NFWeekTab (engineId, targetId, targetName, week ASC, bytes DESC)/**/

--Last month day-data (maximum 31 rows for each target)
CREATE TABLE NFLastMonthTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    day             NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFLastMonthTab PRIMARY KEY (engineId, targetId, targetName, day)
)/**/
CREATE INDEX NFLastMonthTabInd ON NFLastMonthTab (engineId, targetId, targetName)/**/

--All month-data for each target
CREATE TABLE NFMonthTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    month           NUMBER(6)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFMonthTab PRIMARY KEY (engineId, targetId, targetName, month)
)/**/
CREATE UNIQUE INDEX NFMonthTabInd ON NFMonthTab (engineId, targetId, targetName, month ASC, bytes DESC)/**/

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