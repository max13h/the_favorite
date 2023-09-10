class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :content
      t.date :deadline
      t.boolean :is_recurent, default: false
      t.references :user, null: true, foreign_key: true
      t.references :couple, null: false, foreign_key: true

      t.timestamps
    end
  end
end
