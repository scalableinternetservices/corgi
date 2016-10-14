Rails.application.routes.draw do
  root 'pages#home'

  get '/', to: 'pages#home'
  get '/help', to: 'pages#help'
  get '/about', to: 'pages#about'
  get '/signup', to: 'users#new'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :events, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

end
