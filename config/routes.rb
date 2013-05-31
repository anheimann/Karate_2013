Karate67272::Application.routes.draw do

  # get "dojo_student/new"
  # get "dojo_student/edit"
  # get "dojo_student/create"
  # get "dojo_student/update"

  # Generated routes
  resources :dojos
  resources :dojo_students
  resources :events
  resources :registrations
  resources :sections
  resources :sessions
  resources :students
  resources :tournaments
  resources :users
  
  # Named routes (see arbeit_2013 routes.rb lines 29-30 as reference)
  # for the following line of code: match URL (clone in this case) to controller#action, ...
  match 'clone/:id' => 'tournaments#clone', :as => :clone_tournament
  
  # Semi-static page routes
  match 'about' => 'home#about', :as => :about
  match 'contact' => 'home#contact', :as => :contact
  match 'home' => 'home#index', :as => :home
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'privacy' => 'home#privacy', :as => :privacy
  match 'search' => 'home#search', :as => :search
  match 'signup' => 'users#new', :as => :signup
  match 'user/edit' => 'users#edit', :as => :edit_current_user

  # Set the root url
  root :to => 'home#index'
  
end

