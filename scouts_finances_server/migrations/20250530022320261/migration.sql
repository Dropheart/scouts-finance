BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bank_accounts" (
    "id" bigserial PRIMARY KEY,
    "accountNumber" text NOT NULL,
    "sortCode" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "children" (
    "id" bigserial PRIMARY KEY,
    "firstName" text NOT NULL,
    "lastName" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "event_registrations" (
    "id" bigserial PRIMARY KEY,
    "eventId" bigint NOT NULL,
    "childId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "registration_index_idx" ON "event_registrations" USING btree ("eventId", "childId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "payments" (
    "id" bigserial PRIMARY KEY,
    "amount" double precision NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "reference" text NOT NULL,
    "method" text NOT NULL,
    "bankAccountId" bigint,
    "_eventRegistrationsPaymentsEventRegistrationsId" bigint
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "event_registrations"
    ADD CONSTRAINT "event_registrations_fk_0"
    FOREIGN KEY("eventId")
    REFERENCES "events"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "event_registrations"
    ADD CONSTRAINT "event_registrations_fk_1"
    FOREIGN KEY("childId")
    REFERENCES "children"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

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
    VALUES ('scouts_finances', '20250530022320261', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250530022320261', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
