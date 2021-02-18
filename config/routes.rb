Rails.application.routes.draw do

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:show, :new, :edit,:update]

  root to:'static_pages#home'

  post 'create_student', to: 'users#create_student'


end
