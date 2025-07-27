class CreateStreamingApps < ActiveRecord::Migration[8.0]
  def change
    create_table :streaming_apps do |t|
      t.string :name

      t.timestamps
    end
  end
end
