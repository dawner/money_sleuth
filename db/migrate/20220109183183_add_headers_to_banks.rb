class AddHeadersToBanks < ActiveRecord::Migration[6.0]
  def change
    add_column :banks, :headers, :text, array: true, default: []
  end
end
