class Invitation < ApplicationRecord
  belongs_to :event
  belongs_to :user
  validates :unique_uri, uniqueness: true
  enum status: [:no_response, :accepted, :declined, :tentative, :refused]
  delegate :'already_accepted_for_group?', :'full?', :place, :date, to: :event
end
