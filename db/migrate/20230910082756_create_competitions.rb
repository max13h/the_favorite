class CreateCompetitions < ActiveRecord::Migration[7.0]
  def change
    create_table :competitions do |t|
      t.references :family, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :reward
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
