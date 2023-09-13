class AddCoupleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :couple, null: false, foreign_key: true
  end
end
