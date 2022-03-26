class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.date :posted_on, null: false
      t.monetize :value
      t.text :description
      t.integer :status, null: false, default: 0
      t.string :upload_ref
      t.references :bank, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
