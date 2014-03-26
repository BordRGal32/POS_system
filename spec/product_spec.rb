require 'spec_helper'

describe Product do
  it {should have_many :sales}
  it {should have_many(:returns).through(:products_returns)}
end
