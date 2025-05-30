BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "events" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "events" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "cost" double precision NOT NULL
);

INSERT INTO "events" ("name", "date", "cost") VALUES
    ('Event 1', '2023-01-01 10:00:00', 10.00),
    ('Event 2', '2023-02-01 11:00:00', 15.50),
    ('Event 3', '2023-03-01 12:00:00', 20.75),
    ('Event 4', '2023-04-01 13:00:00', 25.25),
    ('Event 5', '2023-05-01 14:00:00', 30.00);

--
-- MIGRATION VERSION FOR scouts_finances
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('scouts_finances', '20250530023937452', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250530023937452', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
