class Group < ApplicationRecord

  validates(:name, presence: true, length: { maximum: 50 })

  #accossiations
  # by deleting group
  # group will be deleted and
  # users who attended this group will no longer be part of it
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  # task which was created for group will be deleted
  has_many :tasks, dependent: :destroy

  # belongs_to :user
  #
  #
  def self.consist_user?(group, user)
    return true if (group.users.exists?(user))
    false
  end
end
