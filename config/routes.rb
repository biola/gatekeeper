Rails.application.routes.draw do
  mount CASino::Engine => '/cas', :as => 'casino'

  resources :users, except: [:index]
  get '/users/:id/confirm/:key', to: 'users#confirm'

  get 'create', to: 'users#new'

  root to: 'users#new'
end
