BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "bank_accounts" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bank_accounts" (
    "id" bigserial PRIMARY KEY,
    "accountNumber" text NOT NULL,
    "sortCode" text NOT NULL,
    "name" text NOT NULL,
    "parentId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "parents" (
    "id" bigserial PRIMARY KEY,
    "firstName" text NOT NULL,
    "lastName" text NOT NULL,
    "email" text NOT NULL,
    "phone" text NOT NULL
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "payments" DROP CONSTRAINT "payments_fk_1";
ALTER TABLE "payments" ADD COLUMN "parentId" bigint;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "bank_accounts"
    ADD CONSTRAINT "bank_accounts_fk_0"
    FOREIGN KEY("parentId")
    REFERENCES "parents"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "payments"
    ADD CONSTRAINT "payments_fk_2"
    FOREIGN KEY("_eventRegistrationsPaymentsEventRegistrationsId")
    REFERENCES "event_registrations"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "payments"
    ADD CONSTRAINT "payments_fk_1"
    FOREIGN KEY("parentId")
    REFERENCES "parents"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR scouts_finances
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('scouts_finances', '20250604191455574', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250604191455574', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
