class User < ApplicationRecord
  has_secure_password

  ## ASSOCIATIONS ##
  has_many :authentications

  ## VALIDATIONS ##
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6, message: "Must be atleast 6 characters" }, if: ->(user) { user.password.present? }

  def self.generate_token(auth_token = nil, &scope)
    scope ||= ->(_) { none }
    auth_token ||= SecureRandom.hex
    auth_token = SecureRandom.hex while scope[auth_token].exists?
    auth_token
  end

  def save_token(options = {})
    auth_token = User.generate_token(options[:auth_token]) { |auth_token| authentications.where(auth_token: auth_token) }
    authentications.create(auth_token: auth_token)
  end
  
end
