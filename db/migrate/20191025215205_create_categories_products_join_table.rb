class CreateCategoriesProductsJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :categories_products do |t|
      t.belongs_to :category, index: true
      t.belongs_to :product, index: true
    end
  end
end
