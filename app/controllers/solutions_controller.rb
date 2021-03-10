class SolutionsController < ApplicationController
  include ApplicationHelper
  before_action :solution_creator_or_group_owner, only: [:show,:edit,:update,:destroy]

  def new
    #apply solution for specific task
    @task = Task.find(params[:task_id])
    @solution = @task.solutions.build()
  end

  def create

    #create new solution for specific task
    @task = Task.find(params[:task_id])

    #solution field is required
    @solution = @task.solutions.build(solution_params)
    # solution belongs to current user
    @solution.user_id = current_user.id

    #solution name (user_name+task_name)
    @solution.name = "#{current_user.name} #{@task.name}"

    #saving solution
    if @solution.save

      flash[:success] = "Solution has been successfully created"
      redirect_to task_path(params[:id],task_id: params[:task_id])
    else
      render 'new'
    end

  end


  #show only for everyone but only creator or teacher can edit
  def show
    @group = Group.find(params[:id])
    # p '======================='
    # p Group.consist_user?(@group,current_user.id)
    # p '==================='
    @solution = Solution.find(params[:solution_id])
  end

  def edit
    @solution = Solution.find(params[:solution_id])
  end

  def update
    @solution = Solution.find(params[:solution_id])

    if @solution.update_attributes(solution_params)
      flash[:success] = "Solution updated"
      redirect_to solution_path(params[:id], task_id: params[:task_id], solution_id: @solution)
    else
      render 'edit'
    end

  end

  # show all user's solution for current task
  def current_task_solutions
    #selecting all user's solution for specific task
    @solutions = current_user.solutions.where(task_id: params[:task_id])
  end

  def destroy

    @solution = Solution.find(params[:solution_id])
    @task  = Task.find(@solution.task_id)

    Solution.find(params[:solution_id]).destroy
    flash[:success] = "Solution has been deleted"
    redirect_to task_path(params[:id],@task)
  end


  private


  def solution_params
    params.require(:solution).permit(:solution)
  end


  def solution_creator_or_group_owner
    @group = Group.find(params[:id])
    @owner = User.find(@group.owner_id)
    @solution = Solution.find(params[:solution_id])

    #do action only if current_user is solution creator or owner of the group
    unless (current_user.id == @solution.user_id) || (current_user.id == @owner.id)
      flash[:danger] = "You are not solution creator/group teacher"
      redirect_to root_path
    end
  end




end
