class CreateRoutineApprovals < ActiveRecord::Migration[7.0]
  def change
    create_table :routine_approvals do |t|
      t.references :routine_execution, null: false, foreign_key: true, index: { unique: true }
      t.references :user, null: false, foreign_key: true
      t.integer :decision, null: false

      t.timestamps
    end
  end
end
