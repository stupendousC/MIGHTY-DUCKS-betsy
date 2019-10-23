class Review < ApplicationRecord
  
  belongs_to :product
  
  # VALIDATIONS:
  # 1.  Rating must be present
  # 2.  Rating must be an integer
  # 3.  Rating must be between and 5
  
  ### If we get around to doing Reviews... 
  # will need migration for Product db to include a new column for avg_ratings with float datatype
  
end
