class RemoveRedundantCcCompanyFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :cc_company
  end
end
