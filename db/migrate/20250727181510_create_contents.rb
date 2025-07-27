class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.string :title
      t.integer :year
      t.integer :duration_in_seconds
      t.string :type
      t.integer :number
      t.integer :season_number

      t.timestamps
    end
  end
end
