class Invitation < ApplicationRecord
  belongs_to :event
  validates :unique_uri, uniqueness: true
  validates :accepted, numericality: { only_integer: true }
  validates :declined, numericality: { only_integer: true }
  validates :tentative, numericality: { only_integer: true }
end
