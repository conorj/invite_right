class Invitation < ApplicationRecord
  belongs_to :event
  validates :unique_uri, uniqueness: true
end
