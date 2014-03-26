class Sale < ActiveRecord::Base
 has_many :products_sales
 has_many :products, through: :products_sales
 belongs_to :cashier

 def sum

 end

end
