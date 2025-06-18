BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "bank_accounts" ADD COLUMN "parentId" bigint;
--
-- ACTION ALTER TABLE
--
DROP INDEX "parent_bank_unique_idx";
ALTER TABLE "parents" DROP CONSTRAINT "parents_fk_0";
ALTER TABLE "parents" DROP COLUMN "bankAccountId";
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
-- MIGRATION VERSION FOR scouts_finances
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('scouts_finances', '20250618031631074', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250618031631074', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
