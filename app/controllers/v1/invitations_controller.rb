module V1
  class InvitationsController < ApplicationController

    def create
      inviteEvent = Event.find_or_create_by(event_params)
      render_json({}, 422) and return unless inviteEvent.valid?

      invite = Invitation.new(event: inviteEvent,
                              unique_uri: SecureRandom.hex[0,10].upcase)
      if invite.save
        render json: invite, status: 201
      else
        render json: { errors: invite.errors }, status: 422
      end
    end

    def status
      invite = Invitation.find_by(invitation_unique_uri)
      if invite.nil?
        render json: {}, status: 404
      else
        render json: { accepted: invite.accepted,
                       declined: invite.declined,
                       tentative: invite.tentative}, status: 200
      end
    end

    private

    def event_params
      params.permit([:place, :date, :time])
    end

    def invitation_unique_uri
      params.permit(:unique_uri)
    end

    def render_json(body, status)
      render json: body, status: status
    end
  end
end
