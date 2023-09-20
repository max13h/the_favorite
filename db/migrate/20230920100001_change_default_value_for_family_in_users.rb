class ChangeDefaultValueForFamilyInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :family_id, :bigint, null: true
  end
end
