class AddFieldToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :teacher, :boolean, default: true
  end
end
