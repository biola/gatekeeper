Rails.application.routes.draw do
  mount CASino::Engine => '/cas', :as => 'casino'

  resources :users, except: [:index]
  get '/users/:id/confirm/:key', to: 'users#confirm', as: 'confirm_user'

  get 'create', to: 'users#new'

  # this is just a convenience to create a named route to rack-cas' logout
  get '/logout' => -> env { [404, { 'Content-Type' => 'text/html' }, ['Rack::CAS should have caught this']] }, as: :logout

  root to: 'users#new'
end
