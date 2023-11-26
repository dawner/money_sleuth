class AddAccountIdToTransactionBatch < ActiveRecord::Migration[7.0]
  def change
    add_reference :transaction_batches, :account, foreign_key: true
  end
end
