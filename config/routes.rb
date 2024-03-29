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
  # mount ActionCable.server => '/cable'

  get 'current_user', to: 'current_user#index'
  get '/users/search', to: 'users#search'

  resources :users do
    resources :posts do
      resources :comments
      resources :likes, only: [:create, :destroy]
    end
    resources :comments do
      resources :likes, only: [:create, :destroy]
    end
    resources :messages
  end

  post 'users/:user_id/posts/:post_id/comments/:id', to: 'comments#create_comment'

  get '/friend_requests/all_sent/:id', to: 'friend_requests#all_sent'

  patch '/friend_requests/:user_id/:id', to: 'friend_requests#update'

  get '/users/:user_id/user_and_friends_posts', to: 'posts#homepage'
  root 'users#index'

  get '/users/:user_id/friend_requests/:id', to: 'users#show_user'
    
  get '/users/allFriends/:id', to: 'users#all_friends' 

  get '/users/getFriends/:id', to: 'users#retrieve_friends'


  delete '/friendships/:current_user_id/:friend_user_id', to: 'friendships#destroy'


  resources :friendships, only: [:create]

  resources :friend_requests, only: [:create, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
