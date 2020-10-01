# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_01_111501) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "translation_manager_approvals", force: :cascade do |t|
    t.integer "translation_manager_suggestion_id", null: false
    t.integer "approved_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["translation_manager_suggestion_id"], name: "suggestion_approval"
  end

  create_table "translation_manager_imports", force: :cascade do |t|
    t.string "status", default: "processing", null: false
    t.string "namespace"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "translation_manager_suggestions", force: :cascade do |t|
    t.string "suggestion"
    t.integer "translation_manager_translation_id", null: false
    t.integer "translator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["translation_manager_translation_id"], name: "suggestion_translation"
  end

  create_table "translation_manager_translations", force: :cascade do |t|
    t.string "key", null: false
    t.integer "version", null: false
    t.string "value", default: "", null: false
    t.string "language", null: false
    t.string "namespace", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "stale", default: false, null: false
    t.integer "translator_id"
    t.index ["key", "version", "namespace", "language"], name: "main_index", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "translation_manager_approvals", "translation_manager_suggestions"
  add_foreign_key "translation_manager_suggestions", "translation_manager_translations"
end
