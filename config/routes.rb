Rails.application.routes.draw do
  get 'notifications/:id/link_through', to: 'notifications#link_through',
                                        as: :link_through
  get 'notifications', to: 'notifications#index'

  root 'pages#home'

  get '/', to: 'pages#home'
  get '/help', to: 'pages#help'
  get '/about', to: 'pages#about'
  post '/search', to: 'pages#search'
  get '/signup', to: 'users#new'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :events, only: [:create, :destroy, :show, :edit, :update, :new] do
  	resources :comments
  end
  resources :events, only: [:create, :destroy, :show, :edit, :update]

  resources :relationships, only: [:create, :destroy]
  resources :invites, only: [:create, :destroy]

end
