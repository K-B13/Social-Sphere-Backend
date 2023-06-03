Rails.application.routes.draw do
  
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get 'current_user', to: 'current_user#index'
  get '/users/search', to: 'users#search'

  resources :users do
    resources :posts do
      resources :comments
    end
  end
  
  resources :friendships, only: [:create, :destroy]
  resources :friend_requests, only: [:create, :update, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
