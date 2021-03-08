class Solution < ApplicationRecord
  belongs_to :user
  belongs_to :task

  #validations
  validates(:solution, presence: true)
end
