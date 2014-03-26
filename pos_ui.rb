require 'Date'
require 'active_record'
require './lib/sale'
require './lib/product'
require './lib/cashier'
require './lib/products_sale'
require './lib/return'
require './lib/products_return'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
puts "Welcome to this super-rad POS system"
main_menu
end

def main_menu
  choice = nil
  until choice == 'e'
    puts "press 'p' for the product menu, 'c' for the cashier menu, 's' for sales menu, 'm' for the store_manager menu, press 'r' to process a return, 'e' to exit"
    choice = gets.chomp
    case choice
      when 'p'
        product_menu
      when 'c'
        cashier_menu
      when 's'
        sales_menu
      when 'm'
        store_manager
      when 'r'
        return_menu
      when 'e'
        puts "goodbye"
        exit
    end
  end
end

def store_manager
  puts "press 'r' to review sales over a given time period, press 'c' to review the performance of each cashier, 'p' to review how many of each product has been sold, 's' to review how many of each product have been returned, or press 'm' to return to the main menu"
  choice = gets.chomp
  case choice
  when 'r'
    review_sales_by_date
  when 'c'
    review_cashier_performance
  when 'p'
    product_review
  when 's'
    return_summary
  when 'm'
    main_menu
  end
end

def product_review
  Product.all.each do |product|
    puts product.name + ": " + product.sales.length.to_s
  end
end

def review_sales_by_date
  puts "what is the date that you would like to review"
  selected_date = gets.chomp
  sales = Sale.where(date: selected_date)
  sales.each_with_index do |sale, index|
    puts sale.products.sum(:price)
  end
end

def review_cashier_performance
  total = 0
  puts "Which cashier's performance to you want to review?"
  find_cashier
  sales = Sale.where(cashier_id: @cashier.id)
  sales.each do |sale|
    total += sale.products.sum(:price)

  end
  puts "Cashier #{@cashier.login_name} has sold $#{total} in merchandise."
end

def return_menu
    puts "#{@logged_cashier.login_name} is currently logged in. press 'n' if that isn't you 'c' to continue"
  choice = gets.chomp
  case choice
  when 'n'
    cashier_login
  when 'c'
    @new_return = Return.create({:cashier_id => @logged_cashier.id, :date => Date.today})
    puts @new_return
    puts @new_return.products
  end
  add_to_return
end

def add_to_return
  find_product
  @new_return.products << @product
  sum = @new_return.products.sum(:price)
  puts "Current total: $#{sum} \n Do you want to add another product (y/n) to this return?"
  choice = gets.chomp
  case choice
  when 'y'
    add_to_return
  when 'n'
    finalize_return
  end
end

def finalize_return
  puts "Return receipt:"
  @new_return.products.each{|product| puts product.name + ": " + product.price.to_s + "\n"}
  sum = @new_return.products.sum(:price)
  puts "Total: #{sum}"
  gets
end

def return_summary
  Return.all.each do |product|
    puts product.name + ": " + product.return.length.to_s
  end
end

def sales_menu
  puts "press 'n' to begin a new sale, 'f' to remove a product from this sale, 'd' to finalize the sale and display receipt, or 'e' to return to the main menu."
  choice = gets.chomp
  case choice
  when 'n'
    new_sale
  when 'f'
    remove_product
  when 'd'
    finalize
  when 'e'
    main_menu
  end
end

def new_sale
  puts "#{@logged_cashier.login_name} is currently logged in. press 'n' if that isn't you 'c' to continue"
  choice = gets.chomp
  case choice
  when 'n'
    cashier_login
  when 'c'
   @new_sale = Sale.create({:cashier_id => @logged_cashier.id, :date => Date.today})
   add_product_to_sale
  end
end

def add_product_to_sale
  find_product
  @new_sale.products << @product
  sum = @new_sale.products.sum(:price)
  puts "Current total: $#{sum} \n Do you want to add another product (y/n)?"
  choice = gets.chomp
  case choice
  when choice = 'y'
    add_product_to_sale
  when choice = 'n'
    finalize_sale
  end
end

def finalize_sale
  puts "Receipt:"
  @new_sale.products.each{|product| puts product.name + ": " + product.price.to_s + "\n"}
  sum = @new_sale.products.sum(:price)
  puts "Total: #{sum}"
  gets
end

def product_menu
  puts "press 'a' to add a new product, press 'p' to update the price of a product, press 's' to search for a product by name, press 'd' to delete a product, press 'l' to list all products, press 'm' to return to the main menu"
  choice = gets.chomp
  case choice
  when 'a'
    add_product
  when 'p'
    update_price
  when 'd'
    delete_product
  when 'l'
    list_product
  when 's'
    find_product
  when 'm'
    main_menu
  end
end

def cashier_menu
  puts "Press 'a' to add a cashier, 'r' to list all cashiers, 'd' to delete a cashier, 'l' to log a cashier in, or 'e' to return to the main menu."
  choice = gets.chomp
  case choice
  when 'a'
    add_cashier
  when 'd'
    delete_cashier
  when 'l'
    cashier_login
  when 'r'
    list_cashiers
  when 'e'
    main_menu
  end
end

def add_cashier
 puts "Please enter the login name of the cashier:"
 cashier_name = gets.chomp
 cashier = Cashier.create({:login_name => cashier_name})
 puts "Cashier #{cashier.login_name} created."
 cashier_menu
rescue
  puts "oops, something went wrong"
end

def find_cashier
  puts "Please enter the name of the cashier to log in:"
  cashier_name = gets.chomp
  @cashier = Cashier.find_by login_name: cashier_name
rescue
  puts "that cashier does not exist try_again"
  find_cashier
end

def list_cashiers
  Cashier.all.each {|cashier| puts cashier.login_name}
  cashier_menu
end

def cashier_login
  find_cashier
  @logged_cashier = @cashier
  puts "#{@logged_cashier.login_name} is now logged in"
end

def delete_cashier
  find_cashier
  @cashier.destroy
  puts "#{@cashier.name} has been deleted from the system"
  cashier_menu
end

def add_product
  puts "Enter the product's name:"
  print ">"
  product_name = gets.chomp
  puts "Enter the product's price:"
  print ">"
  product_price = gets.chomp
  product = Product.create(:name => product_name, :price => product_price)
  puts "Product '#{product_name}' created with a price of $#{product_price}."
end

def list_product
  puts "Products in inventory:"
  Product.all.each { |product| puts "#{product.name} : $#{product.price}" }
end

def find_product
  puts "What product are you looking for?"
  print ">"
  product_to_find = gets.chomp
  @product = Product.find_by name: product_to_find
  @product
rescue
  puts "Invalid entry!"
end

def delete_product
  find_product
  @product.destroy
  puts "#{@product.name} deleted."
 rescue
   puts "Something went wrong."
end

def update_price
  find_product
  puts "Please enter the new price for #{@product.name}:"
  print ">"
  new_price = gets.chomp
  @product.update(price: new_price)
rescue
  "Invalid entry!"
end

welcome
