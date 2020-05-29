-- Copyright 2004-2020 H2 Group. Multiple-Licensed under the MPL 2.0,
-- and the EPL 1.0 (https://h2database.com/html/license.html).
-- Initial Developer: H2 Group
--

CREATE DOMAIN D1 INT DEFAULT 1;
> ok

CREATE DOMAIN D2 D1 DEFAULT 2;
> ok

CREATE DOMAIN D3 D1;
> ok

CREATE TABLE TEST(ID INT PRIMARY KEY, S1 D1, S2 D2, S3 D3, C1 D1 DEFAULT 4, C2 D2 DEFAULT 5, C3 D3 DEFAULT 6);
> ok

INSERT INTO TEST(ID) VALUES 1;
> update count: 1

TABLE TEST;
> ID S1 S2 S3 C1 C2 C3
> -- -- -- -- -- -- --
> 1  1  2  1  4  5  6
> rows: 1

ALTER DOMAIN D1 SET DEFAULT 3;
> ok

INSERT INTO TEST(ID) VALUES 2;
> update count: 1

SELECT * FROM TEST WHERE ID = 2;
> ID S1 S2 S3 C1 C2 C3
> -- -- -- -- -- -- --
> 2  3  2  3  4  5  6
> rows: 1

ALTER DOMAIN D1 DROP DEFAULT;
> ok

SELECT DOMAIN_NAME, DOMAIN_DEFAULT FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA = 'PUBLIC';
> DOMAIN_NAME DOMAIN_DEFAULT
> ----------- --------------
> D1          null
> D2          2
> D3          3
> rows: 3

SELECT COLUMN_NAME, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'PUBLIC';
> COLUMN_NAME COLUMN_DEFAULT
> ----------- --------------
> C1          4
> C2          5
> C3          6
> ID          null
> S1          3
> S2          null
> S3          null
> rows: 7

ALTER DOMAIN D1 SET DEFAULT 3;
> ok

ALTER DOMAIN D3 DROP DEFAULT;
> ok

ALTER TABLE TEST ALTER COLUMN S1 DROP DEFAULT;
> ok

SELECT DOMAIN_NAME, DOMAIN_DEFAULT FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA = 'PUBLIC';
> DOMAIN_NAME DOMAIN_DEFAULT
> ----------- --------------
> D1          3
> D2          2
> D3          null
> rows: 3

SELECT COLUMN_NAME, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'PUBLIC';
> COLUMN_NAME COLUMN_DEFAULT
> ----------- --------------
> C1          4
> C2          5
> C3          6
> ID          null
> S1          null
> S2          null
> S3          null
> rows: 7

DROP DOMAIN D1 CASCADE;
> ok

SELECT DOMAIN_NAME, DOMAIN_DEFAULT FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA = 'PUBLIC';
> DOMAIN_NAME DOMAIN_DEFAULT
> ----------- --------------
> D2          2
> D3          3
> rows: 2

SELECT COLUMN_NAME, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'PUBLIC';
> COLUMN_NAME COLUMN_DEFAULT
> ----------- --------------
> C1          4
> C2          5
> C3          6
> ID          null
> S1          3
> S2          null
> S3          null
> rows: 7

DROP TABLE TEST;
> ok

DROP DOMAIN D2;
> ok

DROP DOMAIN D3;
> ok

CREATE DOMAIN D1 INT ON UPDATE 1;
> ok

CREATE DOMAIN D2 D1 ON UPDATE 2;
> ok

CREATE DOMAIN D3 D1;
> ok

CREATE TABLE TEST(ID INT PRIMARY KEY, S1 D1, S2 D2, S3 D3, C1 D1 ON UPDATE 4, C2 D2 ON UPDATE 5, C3 D3 ON UPDATE 6);
> ok

ALTER DOMAIN D1 SET ON UPDATE 3;
> ok

ALTER DOMAIN D1 DROP ON UPDATE;
> ok

SELECT DOMAIN_NAME, DOMAIN_ON_UPDATE FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA = 'PUBLIC';
> DOMAIN_NAME DOMAIN_ON_UPDATE
> ----------- ----------------
> D1          null
> D2          2
> D3          3
> rows: 3

SELECT COLUMN_NAME, COLUMN_ON_UPDATE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'PUBLIC';
> COLUMN_NAME COLUMN_ON_UPDATE
> ----------- ----------------
> C1          4
> C2          5
> C3          6
> ID          null
> S1          3
> S2          null
> S3          null
> rows: 7

ALTER DOMAIN D1 SET ON UPDATE 3;
> ok

ALTER DOMAIN D3 DROP ON UPDATE;
> ok

ALTER TABLE TEST ALTER COLUMN S1 DROP ON UPDATE;
> ok

SELECT DOMAIN_NAME, DOMAIN_ON_UPDATE FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA = 'PUBLIC';
> DOMAIN_NAME DOMAIN_ON_UPDATE
> ----------- ----------------
> D1          3
> D2          2
> D3          null
> rows: 3

SELECT COLUMN_NAME, COLUMN_ON_UPDATE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'PUBLIC';
> COLUMN_NAME COLUMN_ON_UPDATE
> ----------- ----------------
> C1          4
> C2          5
> C3          6
> ID          null
> S1          null
> S2          null
> S3          null
> rows: 7

DROP DOMAIN D1 CASCADE;
> ok

SELECT DOMAIN_NAME, DOMAIN_ON_UPDATE FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA = 'PUBLIC';
> DOMAIN_NAME DOMAIN_ON_UPDATE
> ----------- ----------------
> D2          2
> D3          3
> rows: 2

SELECT COLUMN_NAME, COLUMN_ON_UPDATE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'PUBLIC';
> COLUMN_NAME COLUMN_ON_UPDATE
> ----------- ----------------
> C1          4
> C2          5
> C3          6
> ID          null
> S1          3
> S2          null
> S3          null
> rows: 7

DROP TABLE TEST;
> ok

DROP DOMAIN D2;
> ok

DROP DOMAIN D3;
> ok

CREATE DOMAIN D1 AS INT;
> ok

CREATE DOMAIN D2 AS D1;
> ok

CREATE TABLE T(C1 D1, C2 D2, L BIGINT);
> ok

ALTER DOMAIN D1 RENAME TO D3;
> ok

SELECT DOMAIN_NAME, PARENT_DOMAIN_NAME, SQL FROM INFORMATION_SCHEMA.DOMAINS;
> DOMAIN_NAME PARENT_DOMAIN_NAME SQL
> ----------- ------------------ --------------------------------------------
> D2          D3                 CREATE DOMAIN "PUBLIC"."D2" AS "PUBLIC"."D3"
> D3          null               CREATE DOMAIN "PUBLIC"."D3" AS INT
> rows: 2

SELECT COLUMN_NAME, DOMAIN_NAME, COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'T' AND COLUMN_NAME LIKE 'C_';
> COLUMN_NAME DOMAIN_NAME COLUMN_TYPE
> ----------- ----------- -------------
> C1          D3          "PUBLIC"."D3"
> C2          D2          "PUBLIC"."D2"
> rows: 2

@reconnect

SELECT DOMAIN_NAME, PARENT_DOMAIN_NAME, SQL FROM INFORMATION_SCHEMA.DOMAINS;
> DOMAIN_NAME PARENT_DOMAIN_NAME SQL
> ----------- ------------------ --------------------------------------------
> D2          D3                 CREATE DOMAIN "PUBLIC"."D2" AS "PUBLIC"."D3"
> D3          null               CREATE DOMAIN "PUBLIC"."D3" AS INT
> rows: 2

SELECT COLUMN_NAME, DOMAIN_NAME, COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'T' AND COLUMN_NAME LIKE 'C_';
> COLUMN_NAME DOMAIN_NAME COLUMN_TYPE
> ----------- ----------- -------------
> C1          D3          "PUBLIC"."D3"
> C2          D2          "PUBLIC"."D2"
> rows: 2

DROP TABLE T;
> ok

DROP DOMAIN D2;
> ok

DROP DOMAIN D3;
> ok
