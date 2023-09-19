Rails.application.routes.draw do
  devise_for :users
  root to: "pages#root"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :tasks
  get '/assign-task', to: 'tasks#assign_task'
  get '/mark-as-done', to: 'tasks#mark_as_done'
  get '/unmark-as-done', to: 'tasks#unmark_as_done'

  resources :events
  get '/assign-event', to: 'events#assign_event'

  get '/home', to: 'pages#home'
  get '/profil', to: 'users#show', as: "user_profil"

  resources :competitions, only: [:index, :show, :destroy, :new, :create]

  resources :kids, only: [:index]

  get '/increase-score', to: 'scores#increase_score'
  get '/decrease-score', to: 'scores#decrease_score'
  # Defines the root path route ("/")
  # root "articles#index"
end
