Rails.application.routes.draw do
  namespace :admin do
    resources :users, except: [:new, :create]
    resources :deleted_users, only: [:index, :show]

    root to: 'users#index'
  end

  resource :user do
    get :delete, on: :member
  end
  get 'create', to: 'users#new'

  resources :sessions, only: :create
  get '/destroy_session', to: 'sessions#destroy', as: :destroy_session

  get '/confirm/:key', to: 'email_confirmations#confirm', as: :confirm_email
  get '/resend_confirmation', to: 'email_confirmations#resend', as: :resend_confirmation

  get '/forgot_password', to: 'forgot_passwords#new', as: :forgot_password
  patch '/reset_password', to: 'forgot_passwords#create', as: :reset_password

  # this is just a convenience to create a named route to rack-cas' logout
  get '/logout' => -> env { [404, { 'Content-Type' => 'text/html' }, ['Rack::CAS should have caught this']] }, as: :cas_logout

  root to: 'users#new'
end
