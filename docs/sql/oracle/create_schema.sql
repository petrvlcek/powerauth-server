--
--  Create sequences.
--
CREATE SEQUENCE "PA_APPLICATION_SEQ" MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;
CREATE SEQUENCE "PA_APPLICATION_VERSION_SEQ" MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;
CREATE SEQUENCE "PA_MASTER_KEYPAIR_SEQ" MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;
CREATE SEQUENCE "PA_SIGNATURE_AUDIT_SEQ" MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;
CREATE SEQUENCE "PA_ACTIVATION_HISTORY_SEQ" MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;
--
--  DDL for Table PA_ACTIVATION
--
CREATE TABLE "PA_ACTIVATION"
(
    "ACTIVATION_ID"                 VARCHAR2(37 CHAR) NOT NULL PRIMARY KEY,
    "APPLICATION_ID"                NUMBER(19,0) NOT NULL,
    "USER_ID"                       VARCHAR2(255 CHAR) NOT NULL,
    "ACTIVATION_ID_SHORT"           VARCHAR2(255 CHAR) NOT NULL,
    "ACTIVATION_NAME"               VARCHAR2(255 CHAR),
    "ACTIVATION_OTP"                VARCHAR2(255 CHAR) NOT NULL,
    "ACTIVATION_STATUS"             NUMBER(10,0) NOT NULL,
    "BLOCKED_REASON"                VARCHAR2(255 CHAR),
    "COUNTER"                       NUMBER(19,0) NOT NULL,
    "DEVICE_PUBLIC_KEY_BASE64"      VARCHAR2(255 CHAR),
    "EXTRAS"                        VARCHAR2(255 CHAR),
    "FAILED_ATTEMPTS"               NUMBER(19,0) NOT NULL,
    "MAX_FAILED_ATTEMPTS"           NUMBER(19,0) DEFAULT 5 NOT NULL,
    "SERVER_PRIVATE_KEY_BASE64"     VARCHAR2(255 CHAR) NOT NULL,
    "SERVER_PRIVATE_KEY_ENCRYPTION" NUMBER(10,0) DEFAULT 0 NOT NULL,
    "SERVER_PUBLIC_KEY_BASE64"      VARCHAR2(255 CHAR) NOT NULL,
    "TIMESTAMP_ACTIVATION_EXPIRE"   TIMESTAMP (6) NOT NULL,
    "TIMESTAMP_CREATED"             TIMESTAMP (6) NOT NULL,
    "TIMESTAMP_LAST_USED"           TIMESTAMP (6) NOT NULL
    "MASTER_KEYPAIR_ID"             NUMBER(19,0),
    "VERSION"                       NUMBER(2,0) DEFAULT 2 NOT NULL
);

--
--  DDL for Table PA_APPLICATION
--
CREATE TABLE "PA_APPLICATION"
(
    "ID"   NUMBER(19,0) NOT NULL PRIMARY KEY,
    "NAME" VARCHAR2(255 CHAR)
);


--
--  DDL for Table PA_APPLICATION_VERSION
--
CREATE TABLE "PA_APPLICATION_VERSION"
(
    "ID"                 NUMBER(19,0) NOT NULL PRIMARY KEY,
    "APPLICATION_ID"     NUMBER(19,0) NOT NULL,
    "APPLICATION_KEY"    VARCHAR2(255 CHAR),
    "APPLICATION_SECRET" VARCHAR2(255 CHAR),
    "NAME"               VARCHAR2(255 CHAR),
    "SUPPORTED"          NUMBER(1,0)
);

--
--  DDL for Table PA_MASTER_KEYPAIR
--
CREATE TABLE "PA_MASTER_KEYPAIR"
(
    "ID"                        NUMBER(19,0) NOT NULL PRIMARY KEY,
    "APPLICATION_ID"            NUMBER(19,0) NOT NULL,
    "MASTER_KEY_PRIVATE_BASE64" VARCHAR2(255 CHAR) NOT NULL,
    "MASTER_KEY_PUBLIC_BASE64"  VARCHAR2(255 CHAR) NOT NULL,
    "NAME"                      VARCHAR2(255 CHAR),
    "TIMESTAMP_CREATED"         TIMESTAMP (6) NOT NULL
);

--
--  DDL for Table PA_SIGNATURE_AUDIT
--
CREATE TABLE "PA_SIGNATURE_AUDIT"
(
    "ID"                 NUMBER(19,0) NOT NULL PRIMARY KEY,
    "ACTIVATION_ID"      VARCHAR2(37 CHAR) NOT NULL,
    "ACTIVATION_COUNTER" NUMBER(19,0) NOT NULL,
    "ACTIVATION_STATUS"  NUMBER(10,0),
    "ADDITIONAL_INFO"    VARCHAR2(255 CHAR),
    "DATA_BASE64"        CLOB,
    "NOTE"               VARCHAR2(255 CHAR),
    "SIGNATURE_TYPE"     VARCHAR2(255 CHAR) NOT NULL,
    "SIGNATURE"          VARCHAR2(255 CHAR) NOT NULL,
    "TIMESTAMP_CREATED"  TIMESTAMP (6) NOT NULL,
    "VALID"              NUMBER(1,0) DEFAULT 0 NOT NULL
);

--
--  DDL for Table PA_INTEGRATION
--
CREATE TABLE "PA_INTEGRATION"
(
    "ID"                 VARCHAR2(37 CHAR) NOT NULL PRIMARY KEY,
    "NAME"               VARCHAR2(255 CHAR),
    "CLIENT_TOKEN"       VARCHAR2(37 CHAR) NOT NULL,
    "CLIENT_SECRET"      VARCHAR2(37 CHAR) NOT NULL
);

--
--  DDL for Table PA_APPLICATION_CALLBACK
--
CREATE TABLE "PA_APPLICATION_CALLBACK"
(
    "ID"                 VARCHAR2(37 CHAR) NOT NULL PRIMARY KEY,
    "APPLICATION_ID"     NUMBER(19,0) NOT NULL,
    "NAME"               VARCHAR2(255 CHAR),
    "CALLBACK_URL"       VARCHAR2(1024 CHAR)
);

--
-- Create a table for tokens
--

CREATE TABLE "PA_TOKEN"
(
    "TOKEN_ID"           VARCHAR2(37 CHAR) NOT NULL PRIMARY KEY,
    "TOKEN_SECRET"       VARCHAR2(255 CHAR) NOT NULL,
    "ACTIVATION_ID"      VARCHAR2(255 CHAR) NOT NULL,
    "SIGNATURE_TYPE"     VARCHAR2(255 CHAR) NOT NULL,
    "TIMESTAMP_CREATED"  TIMESTAMP (6) NOT NULL
);

--
--  DDL for Table PA_ACTIVATION_HISTORY
--
CREATE TABLE "PA_ACTIVATION_HISTORY"
(
    "ID"                 NUMBER(19,0) NOT NULL PRIMARY KEY,
    "ACTIVATION_ID"      VARCHAR2(37 CHAR) NOT NULL,
    "ACTIVATION_STATUS"  NUMBER(10,0),
    "TIMESTAMP_CREATED"  TIMESTAMP (6) NOT NULL
);

--
--  Ref Constraints for Table PA_ACTIVATION
--
ALTER TABLE "PA_ACTIVATION" ADD CONSTRAINT "ACTIVATION_KEYPAIR_FK" FOREIGN KEY ("MASTER_KEYPAIR_ID") REFERENCES "PA_MASTER_KEYPAIR" ("ID") ENABLE;
ALTER TABLE "PA_ACTIVATION" ADD CONSTRAINT "ACTIVATION_APPLICATION_FK" FOREIGN KEY ("APPLICATION_ID") REFERENCES "PA_APPLICATION" ("ID") ENABLE;

--
--  Ref Constraints for Table PA_APPLICATION_VERSION
--
ALTER TABLE "PA_APPLICATION_VERSION" ADD CONSTRAINT "VERSION_APPLICATION_FK" FOREIGN KEY ("APPLICATION_ID") REFERENCES "PA_APPLICATION" ("ID") ENABLE;

--
--  Ref Constraints for Table PA_MASTER_KEYPAIR
--
ALTER TABLE "PA_MASTER_KEYPAIR" ADD CONSTRAINT "KEYPAIR_APPLICATION_FK" FOREIGN KEY ("APPLICATION_ID") REFERENCES "PA_APPLICATION" ("ID") ENABLE;

--
--  Ref Constraints for Table PA_SIGNATURE_AUDIT
--
ALTER TABLE "PA_SIGNATURE_AUDIT" ADD CONSTRAINT "AUDIT_ACTIVATION_FK" FOREIGN KEY ("ACTIVATION_ID") REFERENCES "PA_ACTIVATION" ("ACTIVATION_ID") ENABLE;

--
--  Ref Constraints for Table PA_TOKEN
--
ALTER TABLE "PA_TOKEN" ADD CONSTRAINT "ACTIVATION_TOKEN_FK" FOREIGN KEY ("ACTIVATION_ID") REFERENCES "PA_ACTIVATION" ("ACTIVATION_ID") ENABLE;

--
--  Ref Constraints for Table PA_ACTIVATION_HISTORY
--
ALTER TABLE "PA_ACTIVATION_HISTORY" ADD CONSTRAINT "HISTORY_ACTIVATION_FK" FOREIGN KEY ("ACTIVATION_ID") REFERENCES "PA_ACTIVATION" ("ACTIVATION_ID") ENABLE;
