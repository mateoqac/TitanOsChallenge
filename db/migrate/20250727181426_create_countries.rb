class CreateCountries < ActiveRecord::Migration[8.0]
  def change
    create_table :countries do |t|
      t.string :code
      t.string :name
      t.boolean :active

      t.timestamps
    end
    add_index :countries, :code, unique: true
  end
end
