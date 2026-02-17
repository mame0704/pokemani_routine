class AddFrequencyAndItemsToRoutines < ActiveRecord::Migration[7.2]
  def change
    add_column :routines, :items, :text
  end
end
