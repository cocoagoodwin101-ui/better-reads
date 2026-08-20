Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "sessions#new"
  
  resource :session
  resources :users
  
  resources :books do
    resources :votes, only: [:create], defaults: { votable_type: "Book" }
  end

  resources :reviews do
    resources :votes, only: [:create], defaults: { votable_type: "Review" }
  end
end
