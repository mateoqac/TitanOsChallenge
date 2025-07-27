class CreateViewingTimes < ActiveRecord::Migration[8.0]
  def change
    create_table :viewing_times do |t|
      t.references :content, null: false, foreign_key: true
      t.integer :user_id
      t.integer :time_watched
      t.datetime :viewed_at

      t.timestamps
    end
  end
end
