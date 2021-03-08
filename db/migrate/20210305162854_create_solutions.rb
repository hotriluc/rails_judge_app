class CreateSolutions < ActiveRecord::Migration[5.2]
  def change
    create_table :solutions do |t|
      t.text :solution
      t.references :user, foreign_key: true, type: :string
      t.references :task, foreign_key: true

      t.timestamps
    end
  end
end
