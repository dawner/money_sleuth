class AddBankFileToTransactionBatch < ActiveRecord::Migration[6.0]
  def change
    add_column :transaction_batches, :bank_file, :string
    remove_column :transaction_batches, :upload_ref, :string
  end
end
