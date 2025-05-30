BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "events" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "date" timestamp without time zone NOT NULL
);

--
-- MIGRATION VERSION FOR scouts_finances
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('scouts_finances', '20250529191909577', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250529191909577', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
