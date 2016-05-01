class User < ActiveRecord::Base
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\.]+[\w+]\.[a-z]+\z/i
  before_save {self.email = email.downcase}
  validates :name, presence: true, length: {minimum: 2}
  validates :password, presence: true, length: {minimum: 7}
  validates :email, presence: true, format: {with: VALID_EMAIL}, uniqueness: {case_sensitive: true}
  has_secure_password
end
