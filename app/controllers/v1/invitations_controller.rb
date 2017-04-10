module V1
  class InvitationsController < ApplicationController
    before_action :get_invite, except: :create

    def create
      render_json({ error: I18n.t('auth_error')}, 401) and return unless admin_user?

      invite = Event.add_invite(event_params)
      if invite.nil?
        render_json({ error: I18n.t('invite_not_found')}, 422)
      else
        render_json(invite, 201)
      end
    end

    def status
      render_status
    end

    def show
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

    def admin_user?
      token = request.headers['X-Api-Key']
      return false unless token

      return false if User.find_by(api_auth_token: token).nil?

      true
    end

    def get_invite
      @invite = Invitation.find_by(invitation_unique_uri)
      render_json({ error: I18n.t('invite_not_found')}, 404) if @invite.nil?
    end

    def handle_invite_response(status)
      # prevent multiple submissions
      render_json({ error: I18n.t('invite_already_replied_to')}, 422) and return unless @invite.no_response?

      # refuse accept action if quota already reached
      status = :refused if (status == :accepted) and @invite.full?

      @invite.update_attribute(:status, status)
      render_status
    end

    def render_status
      render_json({ status: @invite.status }, 200)
    end

    def event_params
      params.permit([:user_id, :place, :max_places])
            .merge(date: "#{params[:date]} #{params[:time]}")
    end

    def invitation_unique_uri
      params.permit(:unique_uri)
    end

    def render_json(body, status)
      render json: body, status: status
    end
  end
end
