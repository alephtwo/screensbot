class CreateScreenshots < ActiveRecord::Migration[5.1]
  def change
    create_table :screenshots, id: :uuid do |t|
      t.integer :order, null: false
      t.string :path, null: false
      t.timestamps
    end

    add_index :screenshots, :order, unique: true
  end
end
