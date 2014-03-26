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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140326000827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cashiers", force: true do |t|
    t.string "login_name"
  end

  create_table "products", force: true do |t|
    t.string  "name"
    t.decimal "price"
  end

  create_table "products_returns", force: true do |t|
    t.integer "products_id"
    t.integer "returns_id"
  end

  create_table "products_sales", force: true do |t|
    t.integer "sale_id"
    t.integer "product_id"
  end

  create_table "returns", force: true do |t|
    t.date    "date"
    t.integer "cashier_id"
  end

  create_table "sales", force: true do |t|
    t.string  "name"
    t.date    "date"
    t.integer "cashier_id"
  end

end
