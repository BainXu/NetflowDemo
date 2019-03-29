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
)/* */
CREATE UNIQUE INDEX NFLastRecordInd ON NFLastRecordTab (engineId, targetId, targetName, bytes DESC)/* */

--Last hour datas
CREATE TABLE NFLastHourTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    collectTime     DATE              NOT NULL,
    CONSTRAINT pk_NFLastHourTab PRIMARY KEY (engineId, targetId, targetName, collectTime)
)/* */
CREATE INDEX NFLastHourTabInd ON NFLastHourTab (engineId, targetId, targetName)/* */

--All hour-data
CREATE TABLE NFHourTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    ihour           NUMBER(10)        NOT NULL,
    CONSTRAINT pk_NFHourTab PRIMARY KEY (engineId, targetId, targetName, ihour)
)/* */
CREATE UNIQUE INDEX NFHourTabInd ON NFHourTab (engineId, targetId, targetName, ihour ASC, bytes DESC)/* */

--Last day hour-data (maximum 24 records for each target)
CREATE TABLE NFLastDayTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    ihour           NUMBER(10)        NOT NULL,
    CONSTRAINT pk_NFLastDayTab PRIMARY KEY (engineId, targetId, targetName, ihour)
)/* */
CREATE INDEX NFLastDayTabInd ON NFLastDayTab (engineId, targetId, targetName)/* */

--All day-data
CREATE TABLE NFDayTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    iday            NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFDayTab PRIMARY KEY (engineId, targetId, targetName, iday)
)/* */
CREATE UNIQUE INDEX NFDayTabInd ON NFDayTab (engineId, targetId, targetName, iday ASC, bytes DESC)/* */

--Last week day-data (maximum 7 rows for each target)
CREATE TABLE NFLastWeekTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    iday            NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFLastWeekTab PRIMARY KEY (engineId, targetId, targetName, iday)
)/* */
CREATE INDEX NFLastWeekTabInd ON NFLastWeekTab (engineId, targetId, targetName)/* */

--All week-data
CREATE TABLE NFWeekTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    iweek           NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFWeekTab PRIMARY KEY (engineId, targetId, targetName, iweek)
)/* */
CREATE UNIQUE INDEX NFWeekTabInd ON NFWeekTab (engineId, targetId, targetName, iweek ASC, bytes DESC)/* */

--Last month day-data (maximum 31 rows for each target)
CREATE TABLE NFLastMonthTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    iday            NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFLastMonthTab PRIMARY KEY (engineId, targetId, targetName, iday)
)/* */
CREATE INDEX NFLastMonthTabInd ON NFLastMonthTab (engineId, targetId, targetName)/* */

--All month-data for each target
CREATE TABLE NFMonthTab (
    engineId        NUMBER(12)        NOT NULL,
    targetId        NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    imonth          NUMBER(6)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT pk_NFMonthTab PRIMARY KEY (engineId, targetId, targetName, imonth)
)/* */
CREATE UNIQUE INDEX NFMonthTabInd ON NFMonthTab (engineId, targetId, targetName, imonth ASC, bytes DESC)/* */
