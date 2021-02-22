class User < ApplicationRecord


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9](_(?!(\.|_))|\.(?!(_|\.))|[a-zA-Z0-9]){3,18}[a-zA-Z0-9]\z/i.freeze

  validates :email, presence: true, uniqueness: true, length: { minimum: 5, maximum: 255 },format: { with: VALID_EMAIL_REGEX }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 25 },format: { with: VALID_USERNAME_REGEX }
  validates :password_digest, presence: true
  # validates :password, presence: true, length: { minimum: 6, maximum: 255 }
  has_secure_password

  has_many  :campaigns, dependent: :destroy



  def self.is_a_valid_email? email
    email =~VALID_EMAIL_REGEX
  end
end
