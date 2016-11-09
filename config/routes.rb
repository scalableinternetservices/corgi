Rails.application.routes.draw do

  get 'notifications/:id/link_through', to: 'notifications#link_through',
                                        as: :link_through
  get 'notifications', to: 'notifications#index'


  get 'profiles/show'

  root 'pages#home'

  get '/help', to: 'pages#help'
  get '/about', to: 'pages#about'
  post '/search', to: 'pages#search'


  get '/explore', to: 'pages#explore'
  get '/signup', to: 'users#new'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

  resources :users, only: [:new, :create, :edit, :update] do
    member do
      get :following, :followers
    end
  end

  resources :events, only: [:create, :destroy, :show, :edit, :update, :new] do
  	resources :comments
  end


  get ':user_name', to: 'profiles#show', as: :profile 
  get ':user_name/edit', to: 'profiles#edit', as: :edit_profile
  patch ':user_name/edit', to: 'profiles#update', as: :update_profile

  post ':user_name/follow_user', to: 'relationships#follow_user', as: :follow_user
  post ':user_name/unfollow_user', to: 'relationships#unfollow_user', as: :unfollow_user



  resources :events, only: [:create, :destroy, :show, :edit, :update, :new] do
    member do
      post 'like'
    end
  end

  resources :invites, only: [:create, :destroy]

end
