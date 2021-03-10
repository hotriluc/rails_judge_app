class SolutionsController < ApplicationController
  include ApplicationHelper
  before_action :solution_creator_or_group_owner, only: [:show,:edit,:update,:destroy]
  before_action :correct_owner, only: [:index, :apply_as_approved]



  def index
    @task = Task.find(params[:task_id])
    @solutions = @task.solutions
  end

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

  def destroy

    @solution = Solution.find(params[:solution_id])
    @task  = Task.find(@solution.task_id)

    Solution.find(params[:solution_id]).destroy
    flash[:success] = "Solution has been deleted"
    redirect_to task_path(params[:id], @task)
  end

  # show all user's solution for current task
  def current_task_solutions
    #selecting all user's solution for specific task
    @solutions = current_user.solutions.where(task_id: params[:task_id])
  end


  # def current_task_final_solutions
  #   @task = Task.find(params[:task_id])
  #   @solutions = @task.solutions.where(state:"final")
  # end


  def apply_as_final

    @solution = Solution.find(params[:solution_id])

    if (@solution.correct_creator?(current_user))
      @solution.mark_final!
      flash[:success] = "Final solution"
      redirect_to solution_path(params[:id], task_id: params[:task_id], solution_id: @solution)
    else
      flash[:danger] = "You are not owner of the solution"
      redirect_to root_path
      end


    # if !(@solution.final?)
    #   @solution.mark_final!
    #   flash[:success] = "Final solution"
    # else
    #   flash[:info] = "Can't be marked as final"
    # end


  end


  def apply_as_approved

    @solution = Solution.find(params[:solution_id])
    if !(@solution.approved?)
      @solution.approve!
      flash[:success] = "Solution has been approved"
    else
      flash[:info] = "You can't change status of approved solution"
    end

    redirect_to solution_path(params[:id], task_id: params[:task_id], solution_id: @solution)
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
