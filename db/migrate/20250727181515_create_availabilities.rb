class CreateAvailabilities < ActiveRecord::Migration[8.0]
  def change
    create_table :availabilities do |t|
      t.references :content, null: false, foreign_key: true
      t.references :streaming_app, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true
      t.jsonb :stream_info

      t.timestamps
    end
  end
end
