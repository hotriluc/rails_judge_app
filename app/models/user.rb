class User < ApplicationRecord
  require 'uuidtools'

  before_save   :downcase_email
  #before creating user generate UUID for him
  before_create :generate_uuid


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

  has_many :groups, through: :user_groups
  #by deleting owner all of his groups must be deleted
  # (=========TO DO!!!)
  # has_one :group, foreign_key: :owner_id, class_name: 'Group',dependent: :destroy



  private

  def downcase_email
    self.email = email.downcase
  end

  # UUID generator
  def generate_uuid
    self.id = UUIDTools::UUID.random_create.to_s
  end


end
