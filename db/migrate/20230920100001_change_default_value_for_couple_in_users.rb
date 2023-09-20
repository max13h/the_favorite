class ChangeDefaultValueForCoupleInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :couple_id, :bigint, null: true
  end
end
