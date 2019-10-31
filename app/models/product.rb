class Product < ApplicationRecord
  has_many :reviews
  has_many :order_items
  belongs_to :merchant
  has_and_belongs_to_many :categories
  
  validates :name, presence: true, uniqueness: true
  # by default numericality doesn't allow value of nil
  validates :price, numericality: { only_integer: true, greater_than: 0 }

  def self.by_merchant(id)
    products = Product.all
    result = []
    products.each do |product|
      if Product.find_by(id: product.id).merchant_id == id.to_i
        result << product
      end
    end
    return result
  end
end
