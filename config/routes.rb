Rails.application.routes.draw do
  mount CASino::Engine => '/cas', :as => 'casino'

  resources :users, except: [:index] do
    get :confirm, on: :member
  end

  root to: 'users#new'
end
