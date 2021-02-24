class GroupsController < ApplicationController
  before_action :authenticate_user!
  #before action (check if user is a teacher and owner)
  # for new create edit update destroy is needed


  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create

    @group = Group.new(group_params)

    if @group.save
      flash[:success] = "Group has been created"
      redirect_to @group
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end


  # update group name
  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(group_params)
      flash[:success] = "Group updated"
      redirect_to @group
    else
      render 'edit'
    end
  end

  def destroy
    Group.find(params[:id]).destroy
    flash[:success] = "Group has been deleted"
    redirect_to current_user
  end



  private


  def group_params
    params.require(:group).permit(:name)
  end

#  student can still create group so we need a methd


end
