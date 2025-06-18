BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "bank_accounts" DROP CONSTRAINT "bank_accounts_fk_0";
ALTER TABLE "bank_accounts" DROP COLUMN "parentId";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "parents" ADD COLUMN "bankAccountId" bigint;
CREATE UNIQUE INDEX "parent_bank_unique_idx" ON "parents" USING btree ("bankAccountId");
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "parents"
    ADD CONSTRAINT "parents_fk_0"
    FOREIGN KEY("bankAccountId")
    REFERENCES "bank_accounts"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR scouts_finances
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('scouts_finances', '20250618030500597', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250618030500597', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
