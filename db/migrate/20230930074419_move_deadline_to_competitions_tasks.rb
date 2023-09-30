class MoveDeadlineToCompetitionsTasks < ActiveRecord::Migration[7.0]
  def change
    remove_column :tasks, :deadline, :date
    add_column :competitions_tasks, :deadline, :datetime
  end
end
