class CreateTransactionBatches < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_batches do |t|
      t.string :upload_ref
      t.references :bank, null: false, foreign_key: true

      t.timestamps
    end

    add_reference :transactions, :transaction_batch, foreign_key: true
    remove_column :transactions, :upload_ref, :string
    remove_reference :transactions, :bank, foreign_key: true
  end
end
