class AddHeaderInFileToBanks < ActiveRecord::Migration[6.0]
  def change
    add_column :banks, :headers_in_file, :boolean, default: true
    add_column :banks, :date_format, :string, default: '%m/%d/%Y'
    add_column :banks, :expenses_negative, :boolean, default: true
  end
end
