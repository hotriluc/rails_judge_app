class TasksController < ApplicationController

  def new
    @group = Group.find(params[:id])
    @task = Task.new
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


  private

  def task_params
    params.require(:task).permit(:name,:description,:language)
  end

end
