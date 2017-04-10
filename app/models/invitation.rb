class Invitation < ApplicationRecord
  belongs_to :event
  validates :unique_uri, uniqueness: true
  enum status: [:no_response, :accepted, :declined, :tentative]
  delegate :place, to: :event
  delegate :date, to: :event
  delegate :time, to: :event
end
