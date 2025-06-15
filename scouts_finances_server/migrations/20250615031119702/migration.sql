BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "children" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "children" (
    "id" bigserial PRIMARY KEY,
    "firstName" text NOT NULL,
    "lastName" text NOT NULL,
    "parentId" bigint NOT NULL,
    "scoutGroupId" bigint NOT NULL
);

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
    "cost" bigint NOT NULL,
    "scoutGroupId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scout_groups" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "children"
    ADD CONSTRAINT "children_fk_0"
    FOREIGN KEY("parentId")
    REFERENCES "parents"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "children"
    ADD CONSTRAINT "children_fk_1"
    FOREIGN KEY("scoutGroupId")
    REFERENCES "scout_groups"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "events"
    ADD CONSTRAINT "events_fk_0"
    FOREIGN KEY("scoutGroupId")
    REFERENCES "scout_groups"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR scouts_finances
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('scouts_finances', '20250615031119702', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250615031119702', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
