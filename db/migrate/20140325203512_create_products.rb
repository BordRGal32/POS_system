class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.column :name, :string
      t.column :price, :decimal

      t.timestamp
    end
    create_table :cashiers do |t|
      t.column :login_name, :string
      t.timestamp
    end
    create_table :sales do |t|
      t.column :name, :string
      t.column :date, :date
      t.column :cashier_id, :int
      t.timestamp
    end
    create_table :products_sales do |t|
    t.belongs_to :sale
    t.belongs_to :product

    end
  end
end
