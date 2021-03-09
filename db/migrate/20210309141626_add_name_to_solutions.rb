class AddNameToSolutions < ActiveRecord::Migration[5.2]
  def change
    add_column :solutions, :name, :string
  end
end
