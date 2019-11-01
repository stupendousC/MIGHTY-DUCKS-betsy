require "test_helper"

describe Category do
  describe "validations" do
    it "can be valid" do
      category = categories(:c1)
      assert(category)
    end

    it "is invalid in name is blank" do
      category = categories(:c1)
      category.name = nil

      expect(category.valid?).must_equal false
    end

    it "is invalid is name isn't unique" do
      category2 = categories(:c2)
      category2.name = "Toys"

      expect(category2.valid?).must_equal false
    end
  end


  describe "relationships" do
    it "has and belongs to many products" do
      category = categories(:c1)

      expect(category.products.first.name).must_equal "product1"
    end
  end
end
