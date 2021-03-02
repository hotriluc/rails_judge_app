Rails.application.routes.draw do

  devise_for :users, controllers: {
    confirmations: 'confirmations'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:index, :show, :new, :edit,:update, :destroy]
  resources :groups, only: [:new,:create,:show, :edit, :update, :destroy]
  # resources :tasks, only: [:show]

  root to:'static_pages#home'
  post 'create_student', to: 'users#create_student'


  get 'my_groups', to: 'groups#my_groups'
  post 'add_to_group/:id', to: 'groups#add_to_my_group', as: 'add_to_group'
  post 'remove_from_group/:id', to: 'groups#remove_from_my_group', as: 'remove_from_group'


  # task for specific group
  get 'groups/:id/new_task', to: 'tasks#new', as: 'new_task'
  post 'groups/:id/create_task', to: 'tasks#create', as: 'create_task'
  get 'groups/:id/tasks/:task_id', to: 'tasks#show', as: 'task'
  get 'groups/:id/tasks/:task_id/edit', to: 'tasks#edit', as: 'edit_task'
  patch 'groups/:id/tasks/:task_id/update', to: 'tasks#update'

end
