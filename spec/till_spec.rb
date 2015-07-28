require 'till'

describe Till do

    let(:subject) {described_class.new({data_file: "hipstercoffee.json" })}
    let(:data) do
                  [
                  {
                    "shopName" => "The Coffee Connection",
                    "address" => "123 Lakeside Way",
                    "phone" => "16503600708",
                    "prices" => [
                      {
                        "Cafe Latte" => 4.75,
                        "Flat White" => 4.75,
                        "Cappucino" => 3.85,
                        "Single Espresso" =>2.05,
                        "Double Espresso" => 3.75,
                        "Americano" => 3.75,
                        "Cortado" =>4.55,
                        "Tea" => 3.65,
                        "Choc Mudcake" => 6.40,
                        "Choc Mousse" =>8.20,
                        "Affogato" => 14.80,
                        "Tiramisu" => 11.40,
                        "Blueberry Muffin" => 4.05,
                        "Chocolate Chip Muffin" =>4.05,
                        "Muffin Of The Day" => 4.55
                      }
                    ]
                  }
                ]
            end

    before do 
      allow(JSON).to receive(:load).and_return(data)
      # allow(subject).to receive(:order_time).and_return(Time.new.strftime("%F %H:%M"))
    end

    it 'can return the shop name' do
      expect(subject.shop_name).to eq "The Coffee Connection"
    end

    it 'can return the date and time of order' do
      expect(subject.order_time).to eq Time.new.strftime("%F %H:%M")
    end

    it"can add Flat White" do
      add_items(["Flat White"])
      expect(subject.total).to eq(4.75)
    end

    it 'can add up two items' do
      add_items(["Flat White", "Flat White"])
      add_items(["Cafe Latte"])
      expect(subject.total).to eq(14.25)
    end

     it 'can know the quantities of each item' do
      add_items(["Flat White", "Flat White", "Cafe Latte"])
      expect(subject.order).to eq [{name: "Flat White", price: 4.75, quantity: 2}, 
        {name: "Cafe Latte", price: 4.75, quantity: 1}]
    end

    it 'can calculate 8.64% tax on order total' do
      add_items(["Flat White", "Flat White", "Cafe Latte"])
      expect(subject.tax_added).to eq (1.23)
    end

    it 'can discount 5% from order over £50' do
      add_items(["Affogato", "Affogato", "Affogato", "Affogato", "Affogato"])
      expect(subject.total).to eq (70.3)
    end

    it 'can calculate a 10% discount for orders containing a muffin' do
      add_items(["Muffin Of The Day", "Cafe Latte"])
      expect(subject.muffin_discount).to eq (0.9)
    end

    it 'can accept cash payment, and calculate change' do
      add_items(["Affogato", "Affogato", "Affogato", "Affogato", "Affogato"])
      subject.cash_payment(80)
      expect(subject.cash_change).to eq (9.7)
    end

    def add_items items
      items.each{ |item| subject.add_item(item)}
    end
end