class SolutionsController < ApplicationController
  include ApplicationHelper

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
    p '==============='
    p params
    p '==============='
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

  def solution_creator
    @solution = Solution.find(params[:id])
    redirect_to root_path unless current_user.id == @solution.user_id
  end


end
