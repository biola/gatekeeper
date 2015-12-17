Rails.application.routes.draw do
  resources :users, except: [:index] do
    get :confirm, on: :member
  end

  root to: 'users#new'
end
