SampleApp::Application.routes.draw do

  resources :password_resets
  resources :users do
    resources :verify_emails, only: [:new, :create], shallow: true
    resources :change_usernames, only: [:edit, :update], shallow: true
    resources :change_emails, only: [:edit, :update], shallow: true
    resources :change_avatars, only: [:edit, :update], shallow: true
  end

  get '/users/:user_id/verify_email_token/:verify_token', 
       to: "verify_emails#create", as: 'verify_email_token'
 
  resources :sessions, only: [:new, :create, :destroy]

  root  'static_pages#home'
  match '/signup',  to: 'users#new', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  match '/home', to: 'static_pages#home', via: 'get'
  match '/help', to: 'static_pages#help', via: 'get'
  match '/about', to: 'static_pages#about', via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

end
