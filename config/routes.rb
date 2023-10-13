Rails.application.routes.draw do
  devise_for :users

  resources :users

  get 'users/show', to: 'users#show'
  post 'users/login', to: 'users#login'

  resources :tasks

  get 'tasks/completed', to: 'tasks#completed'
  get 'tasks/uncompleted', to: 'tasks#uncompleted'
end
