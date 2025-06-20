import { Migration } from '@mikro-orm/migrations';

export class Migration20250620155721 extends Migration {

  override async up(): Promise<void> {
    this.addSql(`create table if not exists "master" ("id" text not null, "customer_id" text not null, "license_number" text null, "subscription_active" boolean not null default false, "certification_date" timestamptz null, "franchisee_id" text null, "specializations" jsonb null, "work_address" text null, "rating" integer null, "reviews_count" integer not null default 0, "is_active" boolean not null default true, "created_at" timestamptz not null default now(), "updated_at" timestamptz not null default now(), "deleted_at" timestamptz null, constraint "master_pkey" primary key ("id"));`);
    this.addSql(`CREATE INDEX IF NOT EXISTS "IDX_master_deleted_at" ON "master" (deleted_at) WHERE deleted_at IS NULL;`);
  }

  override async down(): Promise<void> {
    this.addSql(`drop table if exists "master" cascade;`);
  }

}
