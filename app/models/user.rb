class User < ApplicationRecord
  enum status: [:admin, :customer]
  has_secure_token :api_auth_token
  has_many :invitations
end
