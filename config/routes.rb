Rails.application.routes.draw do
  devise_for :users,
             :controllers => { :registrations => "devise/custom/registrations" }

  root to: "pages#root"

  get '/home/tasks', to: 'pages#home_tasks'
  get '/home/events', to: 'pages#home_events'
  get '/common-pot', to: 'pages#common_pot'

  get '/profile', to: 'users#show'

  resources :families, only: [:new]
  get '/join-family', to: 'families#join_family'
  get '/families/create', to: 'families#create', as: 'create_family'
  get '/families/leave', to: 'families#leave', as: 'leave_family'


  resources :tasks
  get '/assign-task', to: 'competitions_tasks#assign_task'
  get '/mark-as-done', to: 'competitions_tasks#mark_as_done'
  get '/unmark-as-done', to: 'competitions_tasks#unmark_as_done'
  get '/create-competitions-task', to: 'competitions_tasks#create_competitions_task'

  resources :events
  get '/assign-event', to: 'events#assign_event'


  resources :competitions, only: [:index, :show, :destroy, :new, :create]

  resources :kids, only: [:index, :show, :new, :create, :update, :edit]

  get '/increase-score', to: 'scores#increase_score'
  get '/decrease-score', to: 'scores#decrease_score'
  # Defines the root path route ("/")
  # root "articles#index"
end
