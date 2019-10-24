class AddReferenceMerchantFromProduct < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :merchant, foreign_key: true
  end
end
