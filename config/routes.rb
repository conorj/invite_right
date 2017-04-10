Rails.application.routes.draw do
  scope module: :v1, defaults: { format: :json } do
    post '/v1/invitations', to: 'invitations#create', as: 'new_invitation'
    get '/v1/invitation/status/:unique_uri', to: 'invitations#status', as: 'invitation_status'
    get '/v1/invitation/accept/:unique_uri', to: 'invitations#accept', as: 'invitation_accept'
    get '/v1/invitation/decline/:unique_uri', to: 'invitations#decline', as: 'invitation_decline'
    get '/v1/invitation/tentative/:unique_uri', to: 'invitations#tentative', as: 'invitation_tentative'
    get '/v1/invitation/:unique_uri', to: 'invitations#show', as: 'invitation_show'
  end
end
