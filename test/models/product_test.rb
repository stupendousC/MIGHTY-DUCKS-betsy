require "test_helper"
require "pry"
describe Product do
  describe "validations" do
    it "can be valid" do
      new_product = products(:p1)
      assert( new_product )
    end

    it "is invalid if name is blank" do
      new_product = products(:p1)
      new_product.name = nil

      expect(new_product.valid?).must_equal false
    end

    it "is invalid if name isn't unique" do
      new_product = products(:p1)
      new_product2 = products(:p2)
      new_product2.name = "product1"

      expect(new_product2.valid?).must_equal false
    end

    it "is invalid if price is a float less than 0" do
      new_product = products(:p1)
      new_product.price = 0.05

      expect(new_product.valid?).must_equal false
    end
  end

  describe "relationships" do
    it "belongs to a merchant" do
      merchant = merchants(:m1)
      product = products(:p1)

      expect(product.merchant.name).must_equal "ducks-r-us"
    end

    it "has and belongs to one or many categories" do
    end

    it "can have many order items" do
    end

    it "can have many reviews" do
    end
  end
end
