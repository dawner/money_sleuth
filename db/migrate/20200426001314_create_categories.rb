class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :keywords, array: true, default: []

      t.timestamps
    end
  end
end
