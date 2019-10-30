require "test_helper"

describe Review do
  
  describe "relationships" do
    it "product can have many reviews" do
      review = reviews(:r1)
      # product = products(:p1)
      expect(review.product.name).must_equal "product1"
    end
  end
  
  describe "validations" do
    it "Comment Can't be Blank" do
      test_review = Review.create(rating: 4, comment: "")
      is_valid = test_review.valid?
      refute(is_valid)
    end
    
    it "Comment Can't be longer than 250 characters" do
      test_review = Review.create(rating: 4, comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elised do eiusmod tempor
        incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 
        voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
        is_valid = test_review.valid?
        refute(is_valid)
      end
      
      it "Rating can't be Blank" do
        test_review = Review.create(rating: "", comment: "test comment for review")
        is_valid = test_review.valid?
        refute(is_valid)
      end
      
      it "Rating can't be a string" do
        test_review = Review.create(rating: "hello", comment: "test comment for review")
        is_valid = test_review.valid?
        refute(is_valid)
      end
      
      it "will have the required fields" do
        test_review = Review.create(rating: 2, comment: "test comment for review")
        [:rating, :comment].each do |field|
          expect(test_review).must_respond_to field
        end
      end
    end
  end