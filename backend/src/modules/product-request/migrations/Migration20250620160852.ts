import { Migration } from '@mikro-orm/migrations';

export class Migration20250620160852 extends Migration {

  override async up(): Promise<void> {
    this.addSql(`create table if not exists "product_request" ("id" text not null, "client_id" text not null, "master_id" text not null, "product_id" text not null, "status" text check ("status" in ('requested', 'accepted', 'purchased', 'used')) not null default 'requested', "quantity" integer not null default 1, "notes" text null, "created_at" timestamptz not null default now(), "updated_at" timestamptz not null default now(), "deleted_at" timestamptz null, constraint "product_request_pkey" primary key ("id"));`);
    this.addSql(`CREATE INDEX IF NOT EXISTS "IDX_product_request_deleted_at" ON "product_request" (deleted_at) WHERE deleted_at IS NULL;`);
  }

  override async down(): Promise<void> {
    this.addSql(`drop table if exists "product_request" cascade;`);
  }

}
