class User < ActiveRecord::Base
  include Utilities

  has_many :bucket_lists, foreign_key: :created_by

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\.]+[\w+]\.[a-z]+\z/i
  
  before_create :set_status
  validates :name, presence: true, length: { minimum: 2 }
  validates :password, presence: true, length: { minimum: 7 }
  validates :email, presence: true, format: { with: VALID_EMAIL },
                    uniqueness: { case_sensitive: true }
  has_secure_password

  def self.find_by_credentials(auth_params)
    user = find_by(email: auth_params[:email])
    if user && user.authenticate(auth_params[:password])
      user.update_attribute("active_status", true)
      user
    end
  end

  def authentication_payload
    { auth_token: AuthToken.encode(user_id: id) }
  end

  def set_status
    self.active_status = true
  end
end
