class Group < ApplicationRecord

  validates(:name, presence: true, length: { maximum: 50 })

  has_many :user_groups
  has_many :users, through: :user_groups
end
