class Event < ApplicationRecord
  has_many :invitations
  validates :place, presence: true, allow_blank: false
  validates :date, presence: true, allow_blank: false
  validates :max_places, numericality: { only_integer: true }

  def already_accepted_for_group?(user)
    return false if event_group.nil?

    !Event.find_by(event_group: event_group)
          .invitations
          .where(status: :accepted, user: user).empty?
  end

  def self.add_invite(event_params)
    user_id = event_params.delete(:user_id)
    invite_event = Event.create_with(max_places: event_params[:max_places],
                                     event_group: event_params[:event_group])
                        .find_or_create_by(place: event_params[:place],
                                           date: event_params[:date])
    return nil unless invite_event.valid?

    invite = Invitation.create(event: invite_event,
                               user_id: user_id,
                               unique_uri: SecureRandom.hex[0, 10].upcase)
    return nil if invite.new_record?

    invite_event
  end

  def full?
    (max_places > 0) && (invitations.accepted.count >= max_places)
  end
end
