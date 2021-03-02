class TasksController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!
  #before action (check if user is a teacher and owner)
  # for new create edit update destroy is needed

  # before_action :teacher_user, only: []
  before_action :correct_owner, only: [:new, :create, :edit, :update, :destroy]


  def new
    @group = Group.find(params[:id])
    @task = @group.tasks.build
  end

  def create

    @group = Group.find(params[:id])
    # Task belongs to group so use build
    @task = @group.tasks.build(task_params)

    if @task.save
      flash[:success] = "Task has been successfully created"
      redirect_to @group
    else
      render 'new'
    end
  end

  def show
    @group = Group.find(params[:id])
    @task = @group.tasks.find(params[:task_id])

  end


  def edit

    @group = Group.find(params[:id])
    @task = @group.tasks.find(params[:task_id])
  end

  def update
    @group = Group.find(params[:id])
    @task = @group.tasks.find(params[:task_id])

    if @task.update_attributes(task_params)
      flash[:success] = "Task has been updated"
      redirect_to @group
    else
      render 'edit'
    end
  end

  def destroy

  end


  private

  def task_params
    params.require(:task).permit(:name,:description,:language)
  end

end
