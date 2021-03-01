class User < ApplicationRecord
  before_save   :downcase_email



  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable


  #validations
  validates(:name, presence: true, length: { maximum: 50 })
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates(:email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false})



  #accossiations

  #by deleting user he will be deleted from user_groups table
  has_many :user_groups, dependent: :destroy
  #by deleting owner all of his groups will be deleted
  has_many :groups, through: :user_groups, foreign_key: 'owner_id'




  private

  def downcase_email
    self.email = email.downcase
  end



end
