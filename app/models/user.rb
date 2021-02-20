class User < ApplicationRecord

  validates :email,     presence: true, uniqueness: true
  validates :username,  presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates_format_of :email, with: /@/
  has_secure_password
end
