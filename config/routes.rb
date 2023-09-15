Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :tasks
  resources :events

  get '/dashboard', to: 'pages#dashboard'
  get '/profil', to: 'users#show', as: "user_profil"

  resources :competitions, only: [:index]
  resources :kids, only: [:index]
  # Defines the root path route ("/")
  # root "articles#index"
end
