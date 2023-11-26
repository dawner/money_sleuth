class RemoveInstitutionIdFromTransactionBatch < ActiveRecord::Migration[7.0]
  def change
    remove_reference :transaction_batches, :institution, foreign_key: true
  end
end
