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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170530055634) do

  create_table "apps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "app_id"
    t.integer  "node_id"
    t.text     "raw_response", limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "nodes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "ip"
    t.string   "port"
    t.text     "raw_response",    limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "source"
    t.text     "keys",            limit: 65535
    t.text     "crackit_content", limit: 65535
    t.string   "hostname"
    t.text     "hostinfo",        limit: 16777215
    t.text     "region_code",     limit: 65535
    t.text     "tags",            limit: 65535
    t.text     "area_code",       limit: 65535
    t.text     "latitude",        limit: 65535
    t.text     "hostnames",       limit: 65535
    t.text     "postal_code",     limit: 65535
    t.text     "dma_code",        limit: 65535
    t.text     "country_code",    limit: 65535
    t.text     "org",             limit: 65535
    t.text     "data",            limit: 16777215
    t.text     "asn",             limit: 65535
    t.text     "city",            limit: 65535
    t.text     "isp",             limit: 65535
    t.text     "longitude",       limit: 65535
    t.text     "last_update",     limit: 65535
    t.text     "country_code3",   limit: 65535
    t.text     "country_name",    limit: 65535
    t.text     "ip_str",          limit: 65535
    t.text     "os",              limit: 65535
    t.text     "ports",           limit: 65535
    t.string   "hacked_way"
    t.string   "payload"
  end

end
