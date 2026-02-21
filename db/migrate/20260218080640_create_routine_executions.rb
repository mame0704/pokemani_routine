class CreateRoutineExecutions < ActiveRecord::Migration[7.0]
  def change
    create_table :routine_executions do |t|
      t.references :routine, null: false, foreign_key: true
      t.date :executed_on, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :routine_executions,
      [:routine_id, :executed_on],
      unique: true
  end
end
