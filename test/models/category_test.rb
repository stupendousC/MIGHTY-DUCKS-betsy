require "test_helper"

describe Category do
  it "has and can belong to many products" do
    category = categories(:c1)
    product_one = products(:p1)
    product_two = products(:p2)
    expect(category.products).must_include product_one
    expect(category.products).must_include product_two
  end

  it "a product has many categories" do
    product_one = products(:p1)
    category_one = categories(:c1)
    category_two = categories(:c2)
    category_three = categories(:c3)

    expect(product_one.categories).must_include category_one
    expect(product_one.categories).must_include category_two
    expect(product_one.categories).must_include category_three
  end

  it "must have a unique name" do
    test_category = Category.create(name: "Toys")
    is_valid = test_category.valid?
    refute(is_valid)
  end

  it "it must have a name, can't be blank" do
    test_category = Category.create(name: nil)
    is_valid = test_category.valid?
    refute(is_valid)
  end
end
