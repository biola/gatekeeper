Rails.application.routes.draw do
  mount CASino::Engine => '/cas', :as => 'casino'

  resource :user
  get '/user/confirm/:key', to: 'users#confirm', as: 'confirm_user'
  get 'create', to: 'users#new'

  resources :sessions, only: :create
  get 'destroy_session', to: 'sessions#destroy', as: :destroy_session

  # this is just a convenience to create a named route to rack-cas' logout
  get '/logout' => -> env { [404, { 'Content-Type' => 'text/html' }, ['Rack::CAS should have caught this']] }, as: :cas_logout

  root to: 'users#new'
end
