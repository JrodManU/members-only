Rails.application.routes.draw do
  root 'sessions#new'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  get '/signup' => 'users#new'
  post '/signup' => 'users#create'
  resources :users, only: [:show]
end
