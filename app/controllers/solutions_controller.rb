class SolutionsController < ApplicationController


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
      redirect_to @solution
    else
      render 'new'
    end

  end


  def show
    @solution = Solution.find(params[:id])

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
