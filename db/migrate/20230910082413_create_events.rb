class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :content
      t.date :date
      t.references :user, null: true, foreign_key: true
      t.references :couple, null: false, foreign_key: true

      t.timestamps
    end
  end
end
