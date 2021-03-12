class AddJudgeTokenToSolutions < ActiveRecord::Migration[5.2]
  def change
    add_column :solutions, :judge_token, :string, default: '-'
  end
end
