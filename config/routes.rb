BlogStar::Application.routes.draw do
  
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  
  #get 'auth/:provider/callback', to: 'twitter_accounts#create'


   
 devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"},:path_prefix => 'd'

  root to: 'home#home'
  
match '/users',   to: 'users#index',   via: 'get'
match '/users/:id',     to: 'users#show',       via: 'get'
  resources :users, :only =>[:show]

  



end
