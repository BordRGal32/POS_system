class FixTheProductsReturnsTable < ActiveRecord::Migration
  def change
    create_table :returns do |t|
      t.column :date, :date
      t.column :cashier_id, :int
      t.timestamp
    end

    create_table :products_returns do |t|
      t.belongs_to :products
      t.belongs_to :returns
    end
  end
end
