Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "sessions#new"
  
  resource :session
  resources :users
  resources :books do
    member do
      post "upvote"
    end
  end
  
  resources :reviews
end
