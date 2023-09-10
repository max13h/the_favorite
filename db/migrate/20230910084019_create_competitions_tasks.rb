class CreateCompetitionsTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :competitions_tasks do |t|
      t.references :task, null: false, foreign_key: true
      t.references :competition, null: false, foreign_key: true
      t.boolean :is_done, default: false

      t.timestamps
    end
  end
end
