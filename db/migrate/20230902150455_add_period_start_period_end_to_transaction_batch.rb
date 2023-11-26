class AddPeriodStartPeriodEndToTransactionBatch < ActiveRecord::Migration[7.0]
  def change
    add_column :transaction_batches, :period_start, :date
    add_column :transaction_batches, :period_end, :date
  end
end
