require 'rspec'
require 'active_record'
require 'shoulda-matchers'
%w(cashier sale product products_sale return products_return).each{|x| require x}

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
    Sale.all.each {|sale| sale.destroy }
    Product.all.each {|product| product.destroy }
    Cashier.all.each {|cashier| cashier.destroy }
  end
end
