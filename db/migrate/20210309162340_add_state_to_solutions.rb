class AddStateToSolutions < ActiveRecord::Migration[5.2]
  def change
    add_column :solutions, :state, :string, default: "progress"
  end
end
