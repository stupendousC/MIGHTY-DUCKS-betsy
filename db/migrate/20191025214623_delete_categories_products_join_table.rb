class DeleteCategoriesProductsJoinTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :categories_products_joins
  end
end
