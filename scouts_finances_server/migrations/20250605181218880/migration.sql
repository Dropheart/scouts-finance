BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "event_registrations" ADD COLUMN "paidDate" timestamp without time zone;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "payments" DROP CONSTRAINT "payments_fk_2";
ALTER TABLE "payments" DROP COLUMN "_eventRegistrationsPaymentsEventRegistrationsId";

--
-- MIGRATION VERSION FOR scouts_finances
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('scouts_finances', '20250605181218880', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250605181218880', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
