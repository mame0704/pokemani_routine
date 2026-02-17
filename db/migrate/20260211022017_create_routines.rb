class CreateRoutines < ActiveRecord::Migration[7.0]
  def change
    create_table :routines do |t|
      t.references :child, null: false, foreign_key: true
      t.string :title, null: false
      t.boolean :active, null: false

      t.timestamps
    end
  end
end
