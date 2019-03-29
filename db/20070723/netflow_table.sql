--------------------------------------------------------------------------------
--Netflow lastest record table
CREATE TABLE NF_LAST_RECORD (
    DEV_ID          NUMBER(12)        NOT NULL,
    target_ID       NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    collectTime     DATE              NOT NULL,
    CONSTRAINT PK_NF_LAST_RECORD PRIMARY KEY (DEV_ID,target_ID,targetName)
)/* */
CREATE UNIQUE INDEX NF_LAST_RECORD_IND ON NF_LAST_RECORD (DEV_ID, target_ID, targetName, bytes DESC)/* */

--Last hour datas
CREATE TABLE NF_LAST_HOUR (
    DEV_ID          NUMBER(12)        NOT NULL,
    target_ID       NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    collectTime     DATE              NOT NULL,
    CONSTRAINT PK_NF_LAST_HOUR PRIMARY KEY (DEV_ID, target_ID, targetName, collectTime)
)/* */
CREATE INDEX NF_LAST_HOUR_IND ON NF_LAST_HOUR (DEV_ID, target_ID, targetName)/* */

--All hour-data
CREATE TABLE NF_HOUR (
    DEV_ID          NUMBER(12)        NOT NULL,
    target_ID       NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    ihour           NUMBER(10)        NOT NULL,
    CONSTRAINT PK_NF_HOUR PRIMARY KEY (DEV_ID, target_ID, targetName, ihour)
)/* */
CREATE UNIQUE INDEX NF_HOUR_IND ON NF_HOUR (DEV_ID, target_ID, targetName, ihour ASC, bytes DESC)/* */

--Last day hour-data (maximum 24 records for each target)
CREATE TABLE NF_LAST_DAY (
    DEV_ID          NUMBER(12)        NOT NULL,
    target_ID       NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    ihour           NUMBER(10)        NOT NULL,
    CONSTRAINT PK_NF_LAST_DAY PRIMARY KEY (DEV_ID, target_ID, targetName, ihour)
)/* */
CREATE INDEX NF_LAST_DAY_IND ON NF_LAST_DAY (DEV_ID, target_ID, targetName)/* */

--All day-data
CREATE TABLE NF_DAY (
    DEV_ID          NUMBER(12)        NOT NULL,
    target_ID       NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    iday            NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT PK_NF_DAY PRIMARY KEY (DEV_ID, target_ID, targetName, iday)
)/* */
CREATE UNIQUE INDEX NF_DAY_IND ON NF_DAY (DEV_ID, target_ID, targetName, iday ASC, bytes DESC)/* */

--Last week day-data (maximum 7 rows for each target)
CREATE TABLE NF_LAST_WEEK (
    DEV_ID          NUMBER(12)        NOT NULL,
    target_ID       NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    iday            NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT PK_NF_LAST_WEEK PRIMARY KEY (DEV_ID, target_ID, targetName, iday)
)/* */
CREATE INDEX NF_LAST_WEEK_IND ON NF_LAST_WEEK (DEV_ID, target_ID, targetName)/* */

--All week-data
CREATE TABLE NF_WEEK (
    DEV_ID          NUMBER(12)        NOT NULL,
    target_ID       NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    iweek           NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT PK_NF_WEEK PRIMARY KEY (DEV_ID, target_ID, targetName, iweek)
)/* */
CREATE UNIQUE INDEX NF_WEEK_IND ON NF_WEEK (DEV_ID, target_ID, targetName, iweek ASC, bytes DESC)/* */

--Last month day-data (maximum 31 rows for each target)
CREATE TABLE NF_LAST_MONTH (
    DEV_ID          NUMBER(12)        NOT NULL,
    target_ID       NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    iday            NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT PK_NF_LAST_MONTH PRIMARY KEY (DEV_ID, target_ID, targetName, iday)
)/* */
CREATE INDEX NF_LAST_MONTH_IND ON NF_LAST_MONTH (DEV_ID, target_ID, targetName)/* */

--All month-data for each target
CREATE TABLE NF_MONTH (
    DEV_ID          NUMBER(12)        NOT NULL,
    target_ID       NUMBER(12)        NOT NULL, --srcAddr, dstAddr, dstPort, prot, tos
    targetName      VARCHAR2(10)      NOT NULL, --SRC_ADDR,DST_ADDR,DST_PORT,PROT,TOS
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    imonth          NUMBER(6)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT PK_NF_MONTH PRIMARY KEY (DEV_ID, target_ID, targetName, imonth)
)/* */
CREATE UNIQUE INDEX NF_MONTH_IND ON NF_MONTH (DEV_ID, target_ID, targetName, imonth ASC, bytes DESC)/* */
