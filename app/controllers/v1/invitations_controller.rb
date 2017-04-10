module V1
  class InvitationsController < ApplicationController
    before_action :get_invite, except: :create

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
      if @invite.nil?
        render json: {}, status: 404
      else
        render json: { accepted: @invite.accepted,
                       declined: @invite.declined,
                       tentative: @invite.tentative}, status: 200
      end
    end

    def show
      render_json({}, 404) and return if @invite.nil?

      render_json(@invite, 200)
    end

    def accept
      handle_invite_response(:accepted)
    end

    def decline
      handle_invite_response(:declined)
    end

    def tentative
      handle_invite_response(:tentative)
    end

    private

    def get_invite
      @invite = Invitation.find_by(invitation_unique_uri)
    end

    def handle_invite_response(status)
      render_json({}, 404) and return if @invite.nil?

      @invite.increment!(status)
      render_json({}, 200)
    end

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
