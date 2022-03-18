class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, length: {minimum: 6}, :on => :create
  validates_confirmation_of :password
  validates :password, presence: true, :on => :create

  has_many :shifts, dependent: :delete_all, inverse_of: :user
  belongs_to :organization, optional: true
end
