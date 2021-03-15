class SolutionsController < ApplicationController
  include ApplicationHelper
  before_action :solution_creator_or_group_owner, only: [:show,:edit,:update,:destroy]
  before_action :correct_owner, only: [:index, :apply_as_approved]


  # showing all solutions to specific task
  def index

      @task = Task.find(params[:task_id])
      @solutions = @task.solutions.where(state:"final")

    # @task = Task.find(params[:task_id])
    # @solutions = @task.solutions
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

    #User is solution's owner
    if (@solution.correct_creator?(current_user))


      if @solution.final?
        flash[:info] = "The solution is already final state"
      elsif @solution.approved?
        flash[:info] = "The solution can't be marked as final because it has been already approved"
      else
        if !(@solution.judge_token.empty?)
          @solution.mark_final!
          flash[:success] = "The solution has been marked as final"
        else
          flash[:info] = "Judge your solution"
        end
      end

      redirect_to solution_path(params[:id], task_id: params[:task_id], solution_id: @solution)

    #  User is not solution's owner
    else
      flash[:danger] = "You are not owner of the solution"
      redirect_to root_path
    end

  end

  #
  def apply_as_approved

    @solution = Solution.find(params[:solution_id])


    if @solution.approved?
      flash[:info] = "You can't change status of approved solution"
    elsif @solution.progress?
      flash[:info] = "The solution can't be marked as approved because it is in progress state"
    else
      if !(@solution.judge_token.empty?)
        # change state of the solution
        @solution.approve!

        flash[:success] = "The solution has been approved"
        #After approving task use delayed job to send it to the dropbox
        Delayed::Job.enqueue SendApprovedSolutionJob.new(@solution), 1, 10.seconds.from_now
      else
        flash[:info] = "No judge token"
      end
    end


    redirect_to solution_path(params[:id], task_id: params[:task_id], solution_id: @solution)
  end

  #All solutions with approved state
  def all_approved_solutions
    @solutions = Solution.where(state: "approved")
  end

  #Send solution to judge
  def judge_solution

    @solution = Solution.find(params[:solution_id])

    #User is solution's owner
    if @solution.correct_creator?(current_user)
      Delayed::Job.enqueue JudgeSolutionJob.new(@solution)
      flash[:info] = "Your judge token will appear in few seconds"

      redirect_to solution_path(params[:id], task_id: params[:task_id], solution_id: @solution)

    else
      #  User is not solution's owner
      flash[:danger] = "You are not owner of the solution"
      redirect_to root_path
    end

  end

  # download single report
  def download_judge_report
    @solution = Solution.find(params[:solution_id])
    report = @solution.download
    send_data(report, file_name: 'report.json')
  end

  def download_judge_reports
    @task = Task.find(params[:task_id])
    @solutions = @task.solutions.where(state:"final")
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
