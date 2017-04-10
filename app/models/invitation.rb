class Invitation < ApplicationRecord
  belongs_to :event
  belongs_to :user
  validates :unique_uri, uniqueness: true
  enum status: [:no_response, :accepted, :declined, :tentative, :refused]
  delegate :'full?', :place, :date, to: :event
end
