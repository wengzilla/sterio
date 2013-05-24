# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121221002132) do

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "view_count",  :default => 0
    t.integer  "user_id"
    t.boolean  "is_private",  :default => false
    t.boolean  "shared",      :default => false
    t.boolean  "active",      :default => true
    t.string   "token"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "track_indices", :force => true do |t|
    t.integer  "playlist_id"
    t.integer  "track_id"
    t.integer  "position",    :default => 0
    t.integer  "user_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "tracks", :force => true do |t|
    t.string   "external_source"
    t.string   "external_id"
    t.string   "external_author"
    t.string   "title"
    t.string   "image"
    t.text     "data"
    t.integer  "play_count"
    t.integer  "duration"
    t.string   "url"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
