class CreateUserFavorites < ActiveRecord::Migration[8.0]
  def change
    create_table :user_favorites do |t|
      t.integer :user_id
      t.references :favoritable, polymorphic: true, null: false
      t.integer :position

      t.timestamps
    end
  end
end
