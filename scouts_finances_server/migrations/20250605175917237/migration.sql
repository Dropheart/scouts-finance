BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "parents" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "parents" (
    "id" bigserial PRIMARY KEY,
    "firstName" text NOT NULL,
    "lastName" text NOT NULL,
    "email" text NOT NULL,
    "phone" text NOT NULL,
    "balance" bigint NOT NULL
);


--
-- MIGRATION VERSION FOR scouts_finances
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('scouts_finances', '20250605175917237', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250605175917237', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
