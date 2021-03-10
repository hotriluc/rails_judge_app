class TasksController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!
  #before action (check if user is a teacher and owner)
  # for new create edit update destroy is needed

  # Only teacher can do actions with Task resource
  before_action :correct_owner, only: [:new, :create, :edit, :update, :destroy]
  after_action :send_notification, only: [:create, :update]

  def new
    @group = Group.find(params[:id])
    @task = @group.tasks.build
  end

  #create new task
  def create
    #getting specific group
    @group = Group.find(params[:id])
    #build task for specific group
    @task = @group.tasks.build(task_params)

    #saving task
    if @task.save
      # TaskMailer.task_create_notification(@owner, @task).deliver_later
      flash[:success] = "Task has been successfully created"
      redirect_to @group
    else
      render 'new'
    end
  end

  def show

    @group = Group.find(params[:id])
    # p '======================'
    # p Group.consist_user?(@group, current_user.id)
    # p '========================='

    # Only user that in group can view task
    if Group.consist_user?(@group, current_user.id)
      @task = @group.tasks.find(params[:task_id])
    else
      flash[:danger] = "You don't have permission to view this content"
      redirect_to root_path
    end


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
    @group = Group.find(params[:id])
    @group.tasks.delete params[:task_id]

    flash[:danger] = "Task has been deleted"
    redirect_to @group
  end

  private

  def task_params
    params.require(:task).permit(:name,:description,:language)
  end


  # Send notification after create and update task
  def send_notification
    # Getting users of current group
    @group = Group.find(params[:id])
    @users = @group.users

    # Subject for mail
    if action_name == "create"
      subject = "New task creation"
    else
      subject = "Task update"
    end

    # Sending mail to each user of the group
    @users.each do |user|
      TaskMailer.task_create_notification(subject, user, @group, @task).deliver_now
    end

  end


end
