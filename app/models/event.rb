class Event < ApplicationRecord
  has_many :invitations
  validates :place, presence: true, allow_blank: false
  validates :date, presence: true, allow_blank: false #, format: /\A\d\d-\d\d-\d\d\d\d\z/
  validates :time, presence: true, allow_blank: false #, format: /\A\d\d-\d\d\z/
  validates :max_places, numericality: { only_integer: true }

  def self.add_invite(event_params)
    inviteEvent = Event.find_or_create_by(event_params)
    return nil unless inviteEvent.valid?

    invite = Invitation.create(event: inviteEvent,
                               unique_uri: SecureRandom.hex[0,10].upcase)
    return nil if invite.new_record?

    invite
  end

  def full?
    (max_places > 0) and (invitations.accepted.count >= max_places)
  end
end
