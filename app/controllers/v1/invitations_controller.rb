module V1
  class InvitationsController < ApplicationController

    def create
      inviteEvent = Event.find_or_create_by(event_params)
      render_json({}, 422) and return unless inviteEvent.valid?

      invite = Invitation.new(event: inviteEvent,
                              unique_uri: '/invite/' + SecureRandom.hex[0,10].upcase)
      if invite.save
        render json: invite, status: 201
      else
        render json: { errors: invite.errors }, status: 422
      end
    end

    private

    def event_params
      params.permit([:place, :date, :time])# .tap do |event_params|
      #  event_params.require([:place, :date, :time])
      #end
    end

    def render_json(body, status)
      render json: body, status: status
    end
  end
end
