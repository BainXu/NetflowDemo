--------------------------------------------------------------------------------
--Netflow lastest record table
CREATE TABLE NF_CONV_LAST_RECORD (
    DEV_ID          NUMBER(12)        NOT NULL,
    addr1           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    addr2           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    collectTime     DATE              NOT NULL,
    CONSTRAINT PK_NF_CONV_LAST_RECORD PRIMARY KEY (DEV_ID,addr1,addr2)
)/* */
CREATE UNIQUE INDEX NF_CONV_LAST_RECORD_IND ON NF_CONV_LAST_RECORD (DEV_ID, addr1, addr2, bytes DESC)/* */

--Last hour datas
CREATE TABLE NF_CONV_LAST_HOUR (
    DEV_ID          NUMBER(12)        NOT NULL,
    addr1           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    addr2           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    collectTime     DATE              NOT NULL,
    CONSTRAINT PK_NF_CONV_LAST_HOUR PRIMARY KEY (DEV_ID, addr1, addr2, collectTime)
)/* */
CREATE INDEX NF_CONV_LAST_HOUR_IND ON NF_CONV_LAST_HOUR (DEV_ID, addr1, addr2)/* */

--All hour-data
CREATE TABLE NF_CONV_HOUR (
    DEV_ID          NUMBER(12)        NOT NULL,
    addr1           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    addr2           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    ihour           NUMBER(10)        NOT NULL,
    CONSTRAINT PK_NF_CONV_HOUR PRIMARY KEY (DEV_ID, addr1, addr2, ihour)
)/* */
CREATE UNIQUE INDEX NF_CONV_HOUR_IND ON NF_CONV_HOUR (DEV_ID, addr1, addr2, ihour ASC, bytes DESC)/* */

--Last day hour-data (maximum 24 records for each target)
CREATE TABLE NF_CONV_LAST_DAY (
    DEV_ID          NUMBER(12)        NOT NULL,
    addr1           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    addr2           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    ihour           NUMBER(10)        NOT NULL,
    CONSTRAINT PK_NF_CONV_LAST_DAY PRIMARY KEY (DEV_ID, addr1, addr2, ihour)
)/* */
CREATE INDEX NF_CONV_LAST_DAY_IND ON NF_CONV_LAST_DAY (DEV_ID, addr1, addr2)/* */

--All day-data
CREATE TABLE NF_CONV_DAY (
    DEV_ID          NUMBER(12)        NOT NULL,
    addr1           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    addr2           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    iday            NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT PK_NF_CONV_DAY PRIMARY KEY (DEV_ID, addr1, addr2, iday)
)/* */
CREATE UNIQUE INDEX NF_CONV_DAY_IND ON NF_CONV_DAY (DEV_ID, addr1, addr2, iday ASC, bytes DESC)/* */

--Last week day-data (maximum 7 rows for each target)
CREATE TABLE NF_CONV_LAST_WEEK (
    DEV_ID          NUMBER(12)        NOT NULL,
    addr1           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    addr2           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    iday            NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT PK_NF_CONV_LAST_WEEK PRIMARY KEY (DEV_ID, addr1, addr2, iday)
)/* */
CREATE INDEX NF_CONV_LAST_WEEK_IND ON NF_CONV_LAST_WEEK (DEV_ID, addr1, addr2)/* */

--All week-data
CREATE TABLE NF_CONV_WEEK (
    DEV_ID          NUMBER(12)        NOT NULL,
    addr1           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    addr2           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    iweek           NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT PK_NF_CONV_WEEK PRIMARY KEY (DEV_ID, addr1, addr2, iweek)
)/* */
CREATE UNIQUE INDEX NF_CONV_WEEK_IND ON NF_CONV_WEEK (DEV_ID, addr1, addr2, iweek ASC, bytes DESC)/* */

--Last month day-data (maximum 31 rows for each target)
CREATE TABLE NF_CONV_LAST_MONTH (
    DEV_ID          NUMBER(12)        NOT NULL,
    addr1           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    addr2           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    iday            NUMBER(8)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT PK_NF_CONV_LAST_MONTH PRIMARY KEY (DEV_ID, addr1, addr2, iday)
)/* */
CREATE INDEX NF_CONV_LAST_MONTH_IND ON NF_CONV_LAST_MONTH (DEV_ID, addr1, addr2)/* */

--All month-data for each target
CREATE TABLE NF_CONV_MONTH (
    DEV_ID          NUMBER(12)        NOT NULL,
    addr1           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    addr2           NUMBER(12)        NOT NULL, --srcAddr or dstAddr
    pkts            NUMBER(24)        NOT NULL,
    bytes           NUMBER(30)        NOT NULL,
    imonth          NUMBER(6)         NOT NULL,
    counts          NUMBER(8)         NOT NULL,
    CONSTRAINT PK_NF_CONV_MONTH PRIMARY KEY (DEV_ID, addr1, addr2, imonth)
)/* */
CREATE UNIQUE INDEX NF_CONV_MONTH_IND ON NF_CONV_MONTH (DEV_ID, addr1, addr2, imonth ASC, bytes DESC)/* */
