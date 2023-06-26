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
      resources :likes, only: [:create, :destroy]
    end
    resources :comments do
      resources :likes, only: [:create, :destroy]
    end
  end

  post 'users/:user_id/posts/:post_id/comments/:id', to: 'comments#create_comment'

  get '/friend_requests/all_sent/:id', to: 'friend_requests#all_sent'

  get '/users/:user_id/friend_requests/:id', to: 'users#show_user'
  patch '/friend_requests/:user_id/:id', to: 'friend_requests#update'
  delete '/friendships/:current_user_id/:friend_user_id', to: 'friendships#destroy'
  get '/users/getFriends/:id', to: 'users#retrieve_friends'
  get '/users/allFriends/:id', to: 'users#all_friends' 

  get '/users/:user_id/user_and_friends_posts', to: 'posts#homepage'
  get '/', to: 'users#index'

  resources :friendships, only: [:create]

  resources :friend_requests, only: [:create, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
