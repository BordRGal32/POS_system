class ProductsReturn < ActiveRecord::Base
  belongs_to :products
  belongs_to :returns
end
