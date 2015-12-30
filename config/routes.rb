Rails.application.routes.draw do
  mount CASino::Engine => '/cas', :as => 'casino'

  resources :users, except: [:index]
  get '/users/:id/confirm/:key', to: 'users#confirm', as: 'confirm_user'

  get 'create', to: 'users#new'

  root to: 'users#new'
end
