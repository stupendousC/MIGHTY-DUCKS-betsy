class Review < ApplicationRecord
  
  belongs_to :product

  validates :rating, presence: true
  # validates :rating, :inclusion => {:in => [1..5]}
  
  validates :description, presence: true
  # validates :description, presence: true, length: {maximum: 255}, on: :create, allow_nil: false
  

  # VALIDATIONS:
  # 1.  Rating must be present
  # 2.  Rating must be an integer
  # 3.  Rating must be between and 5
  
  ### If we get around to doing Reviews... 
  # will need migration for Product db to include a new column for avg_ratings with float datatype
  

end
