require "test_helper"

describe Review do
  
  #   describe "relationships" do
  #     it "product can have many reviews" do
  #       # Arrange
  #       new_driver.save
  #       driver = Driver.first
        
  #       # Assert
  #       expect(driver.trips.count).must_be :>=, 0
  #       driver.trips.each do |trip|
  #         expect(trip).must_be_instance_of Trip
  #       end
  #     end
  #   end
    
  #   describe "validations" do
  #     it "must have a rating" do
  #       # Arrange
  #       new_driver.name = nil
        
  #       # Assert
  #       expect(new_driver.valid?).must_equal false
  #       expect(new_driver.errors.messages).must_include :name
  #       expect(new_driver.errors.messages[:name]).must_equal ["can't be blank"]
  #     end
      
  #     it "must have a comment" do
  #       # Arrange
  #       new_driver.vin = nil
        
  #       # Assert
  #       expect(new_driver.valid?).must_equal false
  #       expect(new_driver.errors.messages).must_include :vin
  #       expect(new_driver.errors.messages[:vin]).must_equal ["can't be blank"]
  #     end
  #  end
end
