require "test_helper"

describe ReviewsController do
  describe "" do
    it "a review can be createreview saved" do
      
      
      must_respond_with :success
      expect(Review.count).must_be :>, 0
    end
  end
end
# review = product(:p1)
# product = review(:r1)