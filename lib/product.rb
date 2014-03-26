class Product < ActiveRecord::Base
  has_many :products_sales
  has_many :sales, :through => :products_sales
  has_many :products_returns
  has_many :returns, :through => :products_returns

end
