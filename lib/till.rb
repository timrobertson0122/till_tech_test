require 'json'

class Till 

  attr_reader :data, :order
  attr_accessor :cash_change

  def initialize(data)
    @data = JSON.load(File.new(data[:data_file]))[0]
    @order = []
    @cash_change = 0
  end

  def shop_name
    data["shopName"]
  end

  def order_time
    Time.new.strftime("%F %H:%M")
  end

  def add_item(product)
    product_in_order = order.select{|item|item[:name] == product}.first  
     
    data["prices"].first.each do | name, price|
      if product_in_order
        product_in_order[:quantity] += 1 if name == product
      else
        order.push({:name => name, :price => price, :quantity => 1}) if name == product
      end
    end
  end

  def sub_total
    order.inject(0) { |sum, item | sum + (item[:price] * item[:quantity])}
  end

  def tax_added
    tax = (sub_total * 0.0864).round(2)
  end

  def fifty_discount
    sub_total >= 50.00 ? 0.95 : 1
  end

  def muffin_discount
     order.any? { |i| i[:name].include? "Muffin" } ? 0.90 : 1
  end

  def total
    sub_total * fifty_discount * muffin_discount
  end

  def cash_payment(cash)
    self.cash_change = (cash - total).round(2)
  end

end  