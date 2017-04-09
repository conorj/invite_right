class Event < ApplicationRecord
  has_many :invitations
  validates :place, presence: true, allow_blank: false
  validates :date, presence: true, allow_blank: false #, format: /\A\d\d-\d\d-\d\d\d\d\z/
  validates :time, presence: true, allow_blank: false #, format: /\A\d\d-\d\d\z/
end
