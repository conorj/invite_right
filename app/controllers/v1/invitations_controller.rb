module V1
  class InvitationsController < ApplicationController
    before_action :get_invite, except: :create

    def create
      invite = Event.add_invite(event_params)
      if invite.nil?
        render json: {}, status: 422
      else
        render json: invite, status: 201
      end
    end

    def status
      if @invite.nil?
        render json: {}, status: 404
      else
        render json: { status: @invite.status }, status: 200
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

      render_json({}, 422) and return unless @invite.no_response?

      @invite.update_attribute(:status, status)
      render_json({}, 200)
    end

    def event_params
      params.permit([:place, :date, :time, :max_places])
    end

    def invitation_unique_uri
      params.permit(:unique_uri)
    end

    def render_json(body, status)
      render json: body, status: status
    end
  end
end
