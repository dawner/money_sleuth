class AddCurrencyToBanks < ActiveRecord::Migration[6.0]
  def change
    add_column :banks, :currency, :string
  end
end
