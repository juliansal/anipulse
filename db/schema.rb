# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_22_000817) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "catalog_anime_ingestion_batches", force: :cascade do |t|
    t.string "file_name", null: false
    t.string "source", default: "file_upload", null: false
    t.string "status", default: "pending", null: false
    t.integer "records_processed"
    t.integer "records_failed"
    t.string "error_log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.check_constraint "source IN ('file_upload', 'api_call')", name: "batches_source_check"
    t.check_constraint "status IN ('pending', 'processing', 'completed', 'failed')", name: "batches_status_check"
  end

  create_table "catalog_anime_ingestion_imports", force: :cascade do |t|
    t.integer "anime_ingestion_batch_id", null: false
    t.string "status", default: "running", null: false
    t.integer "records_imported"
    t.integer "records_failed"
    t.json "row_errors", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["anime_ingestion_batch_id"], name: "idx_on_anime_ingestion_batch_id_d99e9d5400", unique: true
    t.check_constraint "status IN ('running', 'completed', 'failed')", name: "imports_status_check"
  end

  create_table "catalog_animes", force: :cascade do |t|
    t.integer "anime_id", null: false
    t.string "name", null: false
    t.string "english_name"
    t.string "other_name"
    t.decimal "score", precision: 4, scale: 2
    t.string "genres"
    t.text "synopsis"
    t.string "media_type"
    t.integer "episodes"
    t.string "aired"
    t.string "premiered"
    t.string "status"
    t.string "producers"
    t.string "studios"
    t.integer "popularity"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["anime_id", "name"], name: "index_catalog_animes_on_anime_id_and_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "catalog_anime_ingestion_imports", "catalog_anime_ingestion_batches", column: "anime_ingestion_batch_id"
end
