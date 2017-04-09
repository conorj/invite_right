Rails.application.routes.draw do
  scope module: :v1, defaults: { format: :json } do
    post '/v1/invitations', to: 'invitations#create', as: 'new_invitation'
  end
end
