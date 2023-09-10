class CreateKids < ActiveRecord::Migration[7.0]
  def change
    create_table :kids do |t|
      t.string :name
      t.string :blood_type
      t.string :doctor_number
      t.references :couple, null: false, foreign_key: true

      t.timestamps
    end
  end
end
