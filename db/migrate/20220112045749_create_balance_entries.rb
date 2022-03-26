class CreateBalanceEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :balance_entries do |t|
      t.date :posted_on
      t.monetize :value
      t.references :bank, null: false, foreign_key: true

      t.timestamps
    end
  end
end
