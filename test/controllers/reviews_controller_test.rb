require "test_helper"

describe ReviewsController do
  describe "create" do
    it "A Review Can Be Created For A Product And Responds With Success When Created" do
      product = products(:p1)
      test_review = Review.create(rating: 3, comment:"great product!", product_id: product.id)
  
      get new_product_review_path(product.id)
      
      must_respond_with :success
      expect(test_review).must_be_instance_of Review
      expect(test_review.product).must_equal product
      expect(test_review.comment).must_include "great product!"
    end

    it "A Product Can Have Many Reviews" do
    product = products(:p1)
    test_review_one = Review.create(rating: 1, comment:"It sucks!", product_id: product.id)
    test_review_two = Review.create(rating: 5, comment:"wow!", product_id: product.id)
    get new_product_review_path(product.id)
    
    must_respond_with :success
    expect(test_review_one.comment).must_include "It sucks!"
    expect(test_review_two.comment).must_include "wow"
    end
  end 
end
