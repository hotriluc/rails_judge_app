Rails.application.routes.draw do

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:index, :show, :new, :edit,:update, :destroy]
  resources :groups, only: [:new,:create,:show, :edit, :update, :destroy]


  root to:'static_pages#home'
  post 'create_student', to: 'users#create_student'


  get 'my_groups', to: 'groups#my_groups'
  post 'add_to_group/:id', to: 'groups#add_to_my_group', as: 'add_to_group'
  post 'remove_from_group/:id', to: 'groups#remove_from_my_group', as: 'remove_from_group'




end
