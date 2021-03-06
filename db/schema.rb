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

ActiveRecord::Schema.define(:version => 20121023174632) do

  create_table "buses", :force => true do |t|
    t.string   "lat"
    t.string   "long"
    t.integer  "riders"
    t.integer  "line_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "bus_id"
    t.string   "dir_tag"
  end

  create_table "lines", :force => true do |t|
    t.string   "name"
    t.text     "route"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stops", :force => true do |t|
    t.string   "lat"
    t.string   "long"
    t.integer  "riders"
    t.integer  "line_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "tag"
    t.string   "title"
    t.string   "short_title"
    t.integer  "stop_id"
  end

end
