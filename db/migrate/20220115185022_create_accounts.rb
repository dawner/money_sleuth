class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.integer :account_type, default: 0, null: false
      t.references :institution, null: false, foreign_key: true

      t.timestamps
    end
  end
end
