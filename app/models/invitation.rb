class Invitation < ApplicationRecord
  belongs_to :event
  validates :unique_uri, uniqueness: true
  enum status: [:no_response, :accepted, :declined, :tentative, :refused]
  delegate :'full?', :place, :date, :time, to: :event
end
