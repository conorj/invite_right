module V1
  class InvitationsController < ApplicationController
    before_action :set_invite, except: :create

    def create
      unless admin_user?
        render_json({ error: I18n.t('auth_error') }, 401)
        return
      end

      params[:date_end] ||= params[:date]
      events = EventRange.add_events(event_params)
      if events.empty?
        render_json({ error: I18n.t('error_adding_events') }, 422)
      else
        render_json(events, 201)
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

    def set_invite
      @invite = Invitation.find_by(invitation_unique_uri)
      render_json({ error: I18n.t('invite_not_found') }, 404) if @invite.nil?
    end

    def handle_invite_response(status)
      # prevent multiple submissions
      unless @invite.no_response?
        render_json({ error: I18n.t('invite_already_replied_to') }, 422)
        return
      end

      # refuse accept action if quota already reached
      status = :refused if (status == :accepted) && @invite.full?

      # refuse accept action if already accepted for this recurring event
      if (status == :accepted) &&
         @invite.already_accepted_for_group?(@invite.user)
        status = :refused
      end

      @invite.update_attribute(:status, status)
      render_status
    end

    def render_status
      render_json({ status: @invite.status }, 200)
    end

    def event_params
      params.permit([:user_id, :place, :max_places, :date_start, :date_end])
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
