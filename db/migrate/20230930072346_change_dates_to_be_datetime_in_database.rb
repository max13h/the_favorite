class ChangeDatesToBeDatetimeInDatabase < ActiveRecord::Migration[7.0]
  def change
    change_column :competitions, :start_date, :datetime
    change_column :competitions, :end_date, :datetime
  end
end
