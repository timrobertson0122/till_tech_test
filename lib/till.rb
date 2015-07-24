require 'json'

class Till 

  attr_reader :data, :order

  def initialize(data)
    @data = JSON.load(File.new(data[:data_file]))[0]
    @order = []
  end

  def shop_name
    data["shopName"]
  end

  def add_item(item)
    data["prices"].first.each do | name, price|
      # {name: "Flat White", price: 4.75, quantity: 2}
      order.push({:name => name, :price => price, :quantity => 1}) if name == item
    end
  end

  def total
    order.inject(0) { |sum, item | sum + (item[:price] * item[:quantity])}
  end

end