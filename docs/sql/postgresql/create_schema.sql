--
--  Create sequences.
--
CREATE SEQUENCE "pa_application_seq" MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20;
CREATE SEQUENCE "pa_application_version_seq" MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20;
CREATE SEQUENCE "pa_master_keypair_seq" MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20;
CREATE SEQUENCE "pa_signature_audit_seq" MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20;
CREATE SEQUENCE "pa_activation_history_seq" MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20;
CREATE SEQUENCE "pa_recovery_code_seq" MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20;
CREATE SEQUENCE "pa_recovery_puk_seq" MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20;
CREATE SEQUENCE "pa_recovery_config_seq" MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20;

--
--  DDL for Table PA_ACTIVATION
--
CREATE TABLE "pa_activation"
(
    "activation_id"                 VARCHAR(37) NOT NULL PRIMARY KEY,
    "application_id"                INTEGER NOT NULL,
    "user_id"                       VARCHAR(255) NOT NULL,
    "activation_name"               VARCHAR(255),
    "activation_code"               VARCHAR(255),
    "activation_status"             INTEGER NOT NULL,
    "blocked_reason"                VARCHAR(255),
    "counter"                       INTEGER NOT NULL,
    "ctr_data"                      VARCHAR(255),
    "device_public_key_base64"      VARCHAR(255),
    "extras"                        VARCHAR(255),
    "failed_attempts"               INTEGER NOT NULL,
    "max_failed_attempts"           INTEGER DEFAULT 5 NOT NULL,
    "server_private_key_base64"     VARCHAR(255) NOT NULL,
    "server_private_key_encryption" INTEGER DEFAULT 0 NOT NULL,
    "server_public_key_base64"      VARCHAR(255) NOT NULL,
    "timestamp_activation_expire"   TIMESTAMP (6) NOT NULL,
    "timestamp_created"             TIMESTAMP (6) NOT NULL,
    "timestamp_last_used"           TIMESTAMP (6) NOT NULL,
    "timestamp_last_change"         TIMESTAMP (6),
    "master_keypair_id"             INTEGER,
    "version"                       INTEGER DEFAULT 2
);

--
--  DDL for Table PA_APPLICATION
--
CREATE TABLE "pa_application"
(
    "id"                          INTEGER NOT NULL PRIMARY KEY,
    "name"                        VARCHAR(255) NOT NULL
);


--
--  DDL for Table PA_APPLICATION_VERSION
--
CREATE TABLE "pa_application_version"
(
    "id"                 INTEGER NOT NULL PRIMARY KEY,
    "application_id"     INTEGER NOT NULL,
    "application_key"    VARCHAR(255),
    "application_secret" VARCHAR(255),
    "name"               VARCHAR(255),
    "supported"          BOOLEAN
);

--
--  DDL for Table PA_MASTER_KEYPAIR
--
CREATE TABLE "pa_master_keypair"
(
    "id"                            INTEGER NOT NULL PRIMARY KEY,
    "application_id"                INTEGER NOT NULL,
    "master_key_private_base64"     VARCHAR(255) NOT NULL,
    "master_key_public_base64"      VARCHAR(255) NOT NULL,
    "name"                          VARCHAR(255),
    "timestamp_created"             TIMESTAMP (6) NOT NULL
);

--
--  DDL for Table PA_SIGNATURE_AUDIT
--
CREATE TABLE "pa_signature_audit"
(
    "id"                  INTEGER NOT NULL PRIMARY KEY,
    "activation_id"       VARCHAR(37) NOT NULL,
    "activation_counter"  INTEGER NOT NULL,
    "activation_ctr_data" VARCHAR(255),
    "activation_status"   INTEGER,
    "additional_info"     VARCHAR(255),
    "data_base64"         TEXT,
    "note"                VARCHAR(255),
    "signature_type"      VARCHAR(255) NOT NULL,
    "signature"           VARCHAR(255) NOT NULL,
    "timestamp_created"   TIMESTAMP (6) NOT NULL,
    "valid"               BOOLEAN,
    "version"             INTEGER DEFAULT 2
);

--
--  DDL for Table PA_INTEGRATION
--
CREATE TABLE "pa_integration"
(
    "id"                 VARCHAR(37) NOT NULL PRIMARY KEY,
    "name"               VARCHAR(255),
    "client_token"       VARCHAR(37) NOT NULL,
    "client_secret"      VARCHAR(37) NOT NULL
);

--
--  DDL for Table PA_APPLICATION_CALLBACK
--
CREATE TABLE "pa_application_callback"
(
    "id"                 VARCHAR(37) NOT NULL PRIMARY KEY,
    "application_id"     INTEGER NOT NULL,
    "name"               VARCHAR(255),
    "callback_url"       VARCHAR(1024)
);

--
-- DDL for Table PA_TOKEN
--

CREATE TABLE "pa_token"
(
    "token_id"           VARCHAR(37) NOT NULL PRIMARY KEY,
    "token_secret"       VARCHAR(255) NOT NULL,
    "activation_id"      VARCHAR(255) NOT NULL,
    "signature_type"     VARCHAR(255) NOT NULL,
    "timestamp_created"  TIMESTAMP (6) NOT NULL
);

--
--  DDL for Table PA_ACTIVATION_HISTORY
--
CREATE TABLE "pa_activation_history"
(
    "id"                 INTEGER NOT NULL PRIMARY KEY,
    "activation_id"      VARCHAR(37) NOT NULL,
    "activation_status"  INTEGER,
    "blocked_reason"     VARCHAR(255),
    "external_user_id"   VARCHAR(255),
    "timestamp_created"  TIMESTAMP (6) NOT NULL
);

--
-- DDL for Table PA_RECOVERY_CODE
--

CREATE TABLE "pa_recovery_code" (
    "id"                    INTEGER NOT NULL PRIMARY KEY,
    "recovery_code"         VARCHAR(23) NOT NULL,
    "application_id"        INTEGER NOT NULL,
    "user_id"               VARCHAR(255) NOT NULL,
    "activation_id"         VARCHAR(37),
    "status"                INTEGER NOT NULL,
    "failed_attempts"       INTEGER DEFAULT 0 NOT NULL,
    "max_failed_attempts"   INTEGER DEFAULT 10 NOT NULL,
    "timestamp_created"     TIMESTAMP (6) NOT NULL,
    "timestamp_last_used"   TIMESTAMP (6),
    "timestamp_last_change" TIMESTAMP (6)
);

--
-- DDL for Table PA_RECOVERY_PUK
--

CREATE TABLE "pa_recovery_puk" (
    "id"                    INTEGER NOT NULL PRIMARY KEY,
    "recovery_code_id"      INTEGER NOT NULL,
    "puk"                   VARCHAR(255),
    "puk_encryption"        INTEGER DEFAULT 0 NOT NULL,
    "puk_index"             INTEGER NOT NULL,
    "status"                INTEGER NOT NULL,
    "timestamp_last_change" TIMESTAMP (6)
);

--
-- DDL for Table PA_RECOVERY_CONFIG
--

CREATE TABLE "pa_recovery_config" (
    "id"                            NUMBER(19,0) NOT NULL PRIMARY KEY,
    "application_id"                NUMBER(19,0) NOT NULL,
    "activation_recovery_enabled"   BOOLEAN NOT NULL DEFAULT FALSE,
    "recovery_postcard_enabled"     BOOLEAN NOT NULL DEFAULT FALSE,
    "allow_multiple_recovery_codes" BOOLEAN NOT NULL DEFAULT FALSE,
    "postcard_private_key_base64"   VARCHAR(255),
    "postcard_public_key_base64"    VARCHAR(255),
    "remote_public_key_base64"      VARCHAR(255)
);

--
--  Ref Constraints for Table PA_ACTIVATION
--
ALTER TABLE "pa_activation" ADD CONSTRAINT "activation_keypair_fk" FOREIGN KEY ("master_keypair_id") REFERENCES "pa_master_keypair" ("id");
ALTER TABLE "pa_activation" ADD CONSTRAINT "activation_application_fk" FOREIGN KEY ("application_id") REFERENCES "pa_application" ("id");

--
--  Ref Constraints for Table PA_APPLICATION_VERSION
--
ALTER TABLE "pa_application_version" ADD CONSTRAINT "version_application_fk" FOREIGN KEY ("application_id") REFERENCES "pa_application" ("id");

--
--  Ref Constraints for Table PA_MASTER_KEYPAIR
--
ALTER TABLE "pa_master_keypair" ADD CONSTRAINT "keypair_application_fk" FOREIGN KEY ("application_id") REFERENCES "pa_application" ("id");

--
--  Ref Constraints for Table PA_SIGNATURE_AUDIT
--
ALTER TABLE "pa_signature_audit" ADD CONSTRAINT "audit_activation_fk" FOREIGN KEY ("activation_id") REFERENCES "pa_activation" ("activation_id");

--
--  Ref Constraints for Table PA_APPLICATION_CALLBACK
--
ALTER TABLE "pa_application_callback" ADD CONSTRAINT "callback_application_fk" FOREIGN KEY ("application_id") REFERENCES "pa_application" ("id");

--
--  Ref Constraints for Table PA_TOKEN
--
ALTER TABLE "pa_token" ADD CONSTRAINT "activation_token_fk" FOREIGN KEY ("activation_id") REFERENCES "pa_activation" ("activation_id");

--
--  Ref Constraints for Table PA_ACTIVATION_HISTORY
--
ALTER TABLE "pa_activation_history" ADD CONSTRAINT "history_activation_fk" FOREIGN KEY ("activation_id") REFERENCES "pa_activation" ("activation_id");

--
--  Ref Constraints for Table PA_RECOVERY_CODE
--
ALTER TABLE "pa_recovery_code" ADD CONSTRAINT "recovery_code_application_fk" FOREIGN KEY ("application_id") REFERENCES "pa_application" ("id");
ALTER TABLE "pa_recovery_code" ADD CONSTRAINT "recovery_code_activation_fk" FOREIGN KEY ("activation_id") REFERENCES "pa_activation" ("activation_id");

--
--  Ref Constraints for Table PA_RECOVERY_PUK
--
ALTER TABLE "pa_recovery_puk" ADD CONSTRAINT "recovery_puk_code_fk" FOREIGN KEY ("recovery_code_id") REFERENCES "pa_recovery_code" ("id");

--
--  Ref Constraints for Table PA_RECOVERY_CONFIG
--
ALTER TABLE "pa_recovery_config" ADD CONSTRAINT "recovery_config_app_fk" FOREIGN KEY ("application_id") REFERENCES "pa_application" ("id");

---
--- Indexes for better performance. PostgreSQL does not create indexes on foreign key automatically.
---

CREATE INDEX PA_ACTIVATION_APPLICATION ON PA_ACTIVATION(APPLICATION_ID);

CREATE INDEX PA_ACTIVATION_KEYPAIR ON PA_ACTIVATION(MASTER_KEYPAIR_ID);

CREATE INDEX PA_ACTIVATION_CODE ON PA_ACTIVATION(ACTIVATION_CODE);

CREATE INDEX PA_ACTIVATION_USER_ID ON PA_ACTIVATION(USER_ID);

CREATE INDEX PA_ACTIVATION_HISTORY_ACT ON PA_ACTIVATION_HISTORY(ACTIVATION_ID);

CREATE INDEX PA_ACTIVATION_HISTORY_CREATED ON PA_ACTIVATION_HISTORY(TIMESTAMP_CREATED);

CREATE INDEX PA_APPLICATION_VERSION_APP ON PA_APPLICATION_VERSION(APPLICATION_ID);

CREATE INDEX PA_MASTER_KEYPAIR_APPLICATION ON PA_MASTER_KEYPAIR(APPLICATION_ID);

CREATE UNIQUE INDEX PA_APP_VERSION_APP_KEY ON PA_APPLICATION_VERSION(APPLICATION_KEY);

CREATE INDEX PA_APP_CALLBACK_APP ON PA_APPLICATION_CALLBACK(APPLICATION_ID);

CREATE UNIQUE INDEX PA_INTEGRATION_TOKEN ON PA_INTEGRATION(CLIENT_TOKEN);

CREATE INDEX PA_SIGNATURE_AUDIT_ACTIVATION ON PA_SIGNATURE_AUDIT(ACTIVATION_ID);

CREATE INDEX PA_SIGNATURE_AUDIT_CREATED ON PA_SIGNATURE_AUDIT(TIMESTAMP_CREATED);

CREATE INDEX PA_TOKEN_ACTIVATION ON PA_TOKEN(ACTIVATION_ID);

CREATE INDEX PA_RECOVERY_CODE ON PA_RECOVERY_CODE(RECOVERY_CODE);

CREATE INDEX PA_RECOVERY_CODE_APP ON PA_RECOVERY_CODE(APPLICATION_ID);

CREATE INDEX PA_RECOVERY_CODE_USER ON PA_RECOVERY_CODE(USER_ID);

CREATE INDEX PA_RECOVERY_CODE_ACT ON PA_RECOVERY_CODE(ACTIVATION_ID);

CREATE UNIQUE INDEX PA_RECOVERY_CODE_PUK ON PA_RECOVERY_PUK(RECOVERY_CODE_ID, PUK_INDEX);

CREATE INDEX PA_RECOVERY_PUK_CODE ON PA_RECOVERY_PUK(RECOVERY_CODE_ID);

CREATE UNIQUE INDEX PA_APPLICATION_NAME ON PA_APPLICATION(NAME);
