class FirstMigration < ActiveRecord::Migration
  def change
    create_table "playlists", :force => true do |t|
      t.string   "name"
      t.string   "description"
      t.integer  "view_count",         :default => 0
      t.integer  "user_id"
      t.boolean  "is_private",         :default => false
      t.boolean  "shared",             :default => false
      t.boolean  "active",             :default => true
      t.string   "token"
      t.datetime "created_at",                            :null => false
      t.datetime "updated_at",                            :null => false
    end

    create_table "tracks", :force => true do |t|
      t.integer  "playlist_id"
      t.integer  "track_id"
      t.integer  "position",    :default => 0
      t.integer  "user_id"
      t.string   "external_source"
      t.string   "external_id"
      t.string   "external_author"
      t.string   "title"
      t.string   "image"
      t.text     "data"
      t.integer  "play_count"
      t.integer  "duration"
      t.string   "url"
      t.integer  "rating"
      t.integer  "view_count"
      t.datetime "created_at",      :null => false
      t.datetime "updated_at",      :null => false
    end
  end
end
