class User < ApplicationRecord
  enum role: [:admin, :customer]
  has_secure_token :api_auth_token
  has_many :invitations
end
