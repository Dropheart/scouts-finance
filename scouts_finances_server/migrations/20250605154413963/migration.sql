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
    "parentId" bigint NOT NULL
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


--
-- MIGRATION VERSION FOR scouts_finances
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('scouts_finances', '20250605154413963', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250605154413963', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
