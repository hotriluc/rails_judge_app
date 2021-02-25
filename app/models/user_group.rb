class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group


  #to make sure that user can not be added to the group which he has already enrolled
  validates_uniqueness_of :user_id, :scope => :group_id

end
