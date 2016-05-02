class User < ActiveRecord::Base
  has_many :bucket_lists, foreign_key: :created_by

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\.]+[\w+]\.[a-z]+\z/i
  before_save {self.email = email.downcase}
  validates :name, presence: true, length: {minimum: 2}
  validates :password, presence: true, length: {minimum: 7}
  validates :email, presence: true, format: {with: VALID_EMAIL}, uniqueness: {case_sensitive: true}
  has_secure_password

  def self.find_by_credentials(auth_params)
    user = find_by(email: auth_params[:email])
    if user && user.authenticate(auth_params[:password])
      user.update_attribute('active_status', true)
      user
    else
      nil
    end
  end
end
