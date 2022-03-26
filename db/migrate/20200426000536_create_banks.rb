class CreateBanks < ActiveRecord::Migration[6.0]
  def change
    create_table :banks do |t|
      t.string :slug, null: false
      t.string :name, null: false

      t.timestamps
    end

    add_index :banks, :slug, unique: true
  end
end
