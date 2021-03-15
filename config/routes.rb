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
  patch 'groups/:id/tasks/:task_id', to: 'tasks#update'
  delete 'groups/:id/tasks/:task_id', to: 'tasks#destroy', as: 'delete_task'


  #solutions
  get 'groups/:id/tasks/:task_id/all_solutions', to: 'solutions#index', as: 'solutions'
  get 'groups/:id/tasks/:task_id/new_solution', to: 'solutions#new', as: 'new_solution'
  post 'groups/:id/tasks/:task_id/create_solution', to: 'solutions#create', as: 'create_solution'
  get 'groups/:id/tasks/:task_id/my_solutions', to: 'solutions#current_task_solutions', as: 'my_solutions'
  get 'groups/:id/tasks/:task_id/final_solutions', to: 'solutions#current_task_final_solutions', as: 'final_solutions'
  get 'groups/:id/tasks/:task_id/solutions/:solution_id', to: 'solutions#show', as: 'solution'
  get 'groups/:id/tasks/:task_id/solutions/:solution_id/edit', to: 'solutions#edit', as: 'edit_solution'
  patch 'groups/:id/tasks/:task_id/solutions/:solution_id/', to: 'solutions#update'
  delete 'groups/:id/tasks/:task_id/solutions/:solution_id/', to: 'solutions#destroy', as: 'delete_solution'

  post 'groups/:id/tasks/:task_id/solutions/:solution_id/final', to: 'solutions#apply_as_final', as: 'final_solution'
  post 'groups/:id/tasks/:task_id/solutions/:solution_id/approve', to: 'solutions#apply_as_approved', as: 'approve_solution'
  post 'groups/:id/tasks/:task_id/solutions/:solution_id/judge', to: 'solutions#judge_solution', as: 'judge_solution'
  get 'groups/:id/tasks/:task_id/solutions/:solution_id/report', to: 'solutions#download_judge_report', as: 'download_judge_report'
  get 'groups/:id/tasks/:task_id/all_solutions/download', to: 'solutions#download_judge_reports', as: 'download_judge_reports'

end
