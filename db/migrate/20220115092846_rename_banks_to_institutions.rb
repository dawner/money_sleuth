class RenameBanksToInstitutions < ActiveRecord::Migration[6.0]
  def change
    rename_table :banks, :institutions
    rename_column :balance_entries, :bank_id, :institution_id
    rename_column :transaction_batches, :bank_id, :institution_id
    rename_column :transaction_batches, :bank_file, :file
  end
end
