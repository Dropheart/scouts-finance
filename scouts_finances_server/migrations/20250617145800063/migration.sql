BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "scout_groups" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scout_groups" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "colour" text NOT NULL
);


--
-- MIGRATION VERSION FOR scouts_finances
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('scouts_finances', '20250617145800063', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250617145800063', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
