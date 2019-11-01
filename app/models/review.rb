class Review < ApplicationRecord
  
  belongs_to :product
  
  validates :rating, presence: true
  validates :rating, :inclusion => {:in => 1..5, :message => " %{value} is not a valid rating " }
  
  validates :comment, presence: true, length: {maximum: 255}, on: :create, allow_nil: false
  
  
end
