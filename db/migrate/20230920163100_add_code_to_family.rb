class AddCodeToFamily < ActiveRecord::Migration[7.0]
  def change
    add_column :families, :code, :string, default: nil
  end
end
