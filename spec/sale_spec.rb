require 'spec_helper'

describe Sale do
  it {should have_many :products}
  it {should belong_to :cashier}
end
