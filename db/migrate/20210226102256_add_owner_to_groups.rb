class AddOwnerToGroups < ActiveRecord::Migration[5.2]
  def change
    add_reference :groups, :owner, foreign_key: {to_table: :users}
  end
end
