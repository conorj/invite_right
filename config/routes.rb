Rails.application.routes.draw do
  scope module: :v1, defaults: { format: :json } do
    post '/v1/invitations', to: 'invitations#create', as: 'new_invitation'
    get '/v1/invitation/:unique_uri', to: 'invitations#status', as: 'invitation_status'
  end
end
