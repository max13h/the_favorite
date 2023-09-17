class AddUserToCompetitionsTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :competitions_tasks, :user, null: true, foreign_key: true
  end
end
