require "test_helper"

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
      product = products(:p1)

      expect(product.merchant.name).must_equal "ducks-r-us"
    end

    it "has and belongs to one or many categories" do
      product = product = products(:p1)

      expect(product.categories.first.name).must_equal "Toys"
    end

    it "can have many order items" do
      product = products(:p1)

      expect(product.order_items.count).must_equal 2
    end

    it "can have many reviews" do
      product = products(:p1)

      expect(product.reviews.count).must_equal 2
    end
  end

  describe "self.by_merchant method" do
    it "can return products by a specific merchant" do
      m1 = merchants(:m1)
      products = Product.by_merchant(m1.id)

      expect(products.count).must_equal 2
    end
  end
end
