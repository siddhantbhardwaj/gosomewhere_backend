class Authentication < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :user
  
  ## VALIDATIONS ##
  validates :auth_token, uniqueness: true
end
