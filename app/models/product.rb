class Product < ApplicationRecord
  has_many :reviews
  has_many :order_items
  belongs_to :merchant
  has_and_belongs_to_many :categories
  
  validates :name, presence: true, uniqueness: true
  # by default numericality doesn't allow value of nil
  validates :price, numericality: { only_integer: true, greater_than: 0 }

end
