class Task < ApplicationRecord
  #by deleting group all task will be deleted
  belongs_to :group

  #that means solutions of tasks will be deleted as well
  has_many :solutions, dependent: :destroy
  has_many :users, through: :solutions



  #validations
  validates(:name, presence: true, length: { maximum: 50 })
  validates(:description, presence: true)
  validates(:language, presence: true)
end
