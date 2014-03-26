class Return < ActiveRecord::Base
  has_many :products_returns
  has_many :products, through: :products_returns
  belongs_to :cashier
end
