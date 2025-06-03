BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "payments" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "payments" (
    "id" bigserial PRIMARY KEY,
    "amount" double precision NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "reference" text NOT NULL,
    "method" text NOT NULL,
    "payee" text NOT NULL,
    "bankAccountId" bigint,
    "_eventRegistrationsPaymentsEventRegistrationsId" bigint
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "payments"
    ADD CONSTRAINT "payments_fk_0"
    FOREIGN KEY("bankAccountId")
    REFERENCES "bank_accounts"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "payments"
    ADD CONSTRAINT "payments_fk_1"
    FOREIGN KEY("_eventRegistrationsPaymentsEventRegistrationsId")
    REFERENCES "event_registrations"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR scouts_finances
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('scouts_finances', '20250530125622857', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250530125622857', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
