class Task < ApplicationRecord
  belongs_to :group
  #validations
  validates(:name, presence: true, length: { maximum: 50 })
  validates(:description, presence: true)
  validates(:language, presence: true)
end
