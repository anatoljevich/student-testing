# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090618081847) do

  create_table "authors", :force => true do |t|
    t.string   "login",                     :limit => 20
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "fio"
    t.boolean  "admin",                                   :default => false
  end

  create_table "disciplines", :force => true do |t|
    t.string "name", :limit => 40
  end

  create_table "exam_entities", :force => true do |t|
    t.integer  "exam_id"
    t.string   "result",         :limit => 4096
    t.boolean  "complete",                       :default => false
    t.datetime "created_at"
    t.datetime "finished_at"
    t.integer  "success_topics", :limit => 2
    t.integer  "total_topics",   :limit => 2
    t.integer  "group_id"
    t.integer  "student_id"
    t.string   "exam_variant",   :limit => 1
    t.integer  "score",          :limit => 2
    t.integer  "average",        :limit => 2
  end

  create_table "exam_entity_results", :force => true do |t|
    t.integer "exam_entity_id"
    t.integer "topic_id"
    t.integer "correct"
    t.integer "total"
    t.boolean "success",        :default => false
    t.boolean "important_fail", :default => false
  end

  create_table "exam_topics", :force => true do |t|
    t.integer "topic_id"
    t.integer "count"
    t.integer "passing_score"
    t.integer "exam_id"
    t.boolean "important",     :default => false
  end

  create_table "exams", :force => true do |t|
    t.string  "description"
    t.integer "duration"
    t.integer "passing_score"
    t.boolean "active",                     :default => false
    t.string  "exam_variant",  :limit => 1
  end

  create_table "groups", :force => true do |t|
    t.integer "students_count",               :default => 0
    t.string  "spec",           :limit => 16
    t.integer "number",         :limit => 2
  end

  create_table "questions", :force => true do |t|
    t.integer "topic_id"
    t.integer "author_id"
    t.boolean "multivariant",                 :default => false
    t.string  "name",         :limit => 128
    t.string  "text",         :limit => 2048
    t.string  "answers",      :limit => 2048
    t.string  "type",         :limit => 5
    t.boolean "deleted",                      :default => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "students", :force => true do |t|
    t.string  "surname",     :limit => 32
    t.string  "name",        :limit => 32
    t.string  "parent_name", :limit => 32
    t.integer "group_id"
    t.string  "code",        :limit => 8
    t.boolean "deleted",                   :default => false
  end

  add_index "students", ["group_id"], :name => "index_students_on_group_id"

  create_table "topics", :force => true do |t|
    t.integer "discipline_id"
    t.string  "name"
    t.integer "questions_count", :default => 0
    t.boolean "public",          :default => false
    t.integer "author_id"
  end

end
