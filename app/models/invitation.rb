class Invitation < ApplicationRecord
  belongs_to :event
  belongs_to :user
  validates :unique_uri, uniqueness: true
  enum status: [:no_response, :accepted, :declined, :tentative, :refused]
  delegate :'already_accepted_for_group?', :'full?', :place, :date, to: :event

  def invitation_uri
    "/v1/invitation/#{unique_uri}"
  end

  def invitation_date
    date.strftime('%a, %e %b %Y %k:%M')
  end
end
