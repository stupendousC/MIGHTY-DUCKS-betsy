class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.integer :stock
      t.string :img_url
      t.string :description
      
      t.timestamps
    end
  end
end
