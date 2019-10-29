require "test_helper"

describe OrderItem do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  describe "validations" do 
    before do
      @item = order_items(:oi1)
    end
    it "must be connected to a product" do
      product = Product.find_by(id: @item.product_id)
      expect(product).must_be_instance_of Product
    end
    it "must not be connected to a product that doesn't exist" do
      @item.product_id = "bad_id"
      is_valid = @item.valid?
      refute(is_valid)
    end
    it "must have a quantity" do
      @item.qty = nil
      is_valid = @item.valid?
      refute(is_valid)
    end
    it "must have a quantity greater than 0" do
      @item.qty = 0
      is_valid = @item.valid?
      refute(is_valid)
    end
    it "must have a quantity that is an integer" do
      @item.qty = "twelve"
      is_valid = @item.valid?
      refute(is_valid)
    end
  end

  describe "relationships" do
    before do
      @item = order_items(:oi1)
    end
    it "must be connected to an order" do
      
    end
  end
end
