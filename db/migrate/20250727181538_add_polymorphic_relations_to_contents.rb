class AddPolymorphicRelationsToContents < ActiveRecord::Migration[8.0]
  def change
    add_reference :contents, :tv_show, null: true, foreign_key: { to_table: :contents }
    add_reference :contents, :season, null: true, foreign_key: { to_table: :contents }
    add_reference :contents, :channel, null: true, foreign_key: { to_table: :contents }
  end
end
