class Group < ApplicationRecord

  validates(:name, presence: true, length: { maximum: 50 })


  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups

end
