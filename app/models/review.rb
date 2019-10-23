class Review < ApplicationRecord
  
  belongs_to :product
  
  # VALIDATIONS:
  # 1.  Rating must be present
  # 2.  Rating must be an integer
  # 3.  Rating must be between and 5
  
end
