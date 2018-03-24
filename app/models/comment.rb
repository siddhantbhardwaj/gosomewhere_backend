class Comment < ApplicationRecord

  ## ASSOCIATIONS ##
  belongs_to :event
  belongs_to :user
  
  ## VALIDATIONS ##
  validates :event_id, :user_id, presence: true
  
end
