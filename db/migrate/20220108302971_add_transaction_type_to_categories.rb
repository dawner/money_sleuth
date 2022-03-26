class AddTransactionTypeToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :transaction_type, :integer, default: 0
  end
end
