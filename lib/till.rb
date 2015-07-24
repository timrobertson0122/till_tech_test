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

  def order_time
    Time.new.strftime("%F %H:%M")
  end

  def add_item(item, quantity)
    data["prices"].first.each do | name, price|
      # {name: "Flat White", price: 4.75, quantity: 2}
        order.push({:name => name, :price => price, :quantity => quantity}) if name == item
    end
  end

  def total
    order.inject(0) { |sum, item | sum + (item[:price] * item[:quantity])}
  end

  def tax_added
    tax = (total * 0.0864).round(2)
  end

  def total_after_discount
    total * 0.95 if total > 50.00
  end

  def muffin_discount
    (total * 0.90).round(2) if order.detect { |i| i[:name].include? "Muffin" }
  end

end  