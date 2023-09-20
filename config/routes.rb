Rails.application.routes.draw do
  devise_for :users
  root to: "pages#root"

  get '/home', to: 'pages#home'
  get '/common-pot', to: 'pages#common_pot'

  get '/profile', to: 'users#show'

  resources :families, only: [:new]
  get '/join-family', to: 'families#join_family'
  get '/families/create', to: 'families#create', as: 'create_family'


  resources :tasks
  get '/assign-task', to: 'tasks#assign_task'
  get '/mark-as-done', to: 'tasks#mark_as_done'
  get '/unmark-as-done', to: 'tasks#unmark_as_done'

  resources :events
  get '/assign-event', to: 'events#assign_event'


  resources :competitions, only: [:index, :show, :destroy, :new, :create]

  resources :kids, only: [:index]

  get '/increase-score', to: 'scores#increase_score'
  get '/decrease-score', to: 'scores#decrease_score'
  # Defines the root path route ("/")
  # root "articles#index"
end
