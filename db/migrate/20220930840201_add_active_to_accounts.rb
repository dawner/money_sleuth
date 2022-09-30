class AddActiveToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :active, :boolean, default: true
  end
end
