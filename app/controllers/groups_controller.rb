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
    @group.users = [current_user]
    @group.owner_id = current_user.id


    if @group.save
      flash[:success] = "Group has been created"

      redirect_to @group
    else
      render :new
    end
  end

  def show

    @group = Group.find(params[:id])

    @owner = User.find(@group.owner_id)
    @users = @group.users
    @users_not_in_group = User.where.not(id: @users)
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


  # destroy the group
  def destroy
    Group.find(params[:id]).destroy
    flash[:success] = "Group has been deleted"
    redirect_to current_user
  end


  #current user's groups
  def my_groups

      @groups = current_user.groups

  end


  #add user to group
  def add_to_my_group
    @group = Group.find(params[:id])
    @user = User.find(params[:user])

    #should check if user is in group then add

    @group.users << @user
    @group.save

    redirect_to @group

  end

  #remove user from group
  def remove_from_my_group
    @group = Group.find(params[:id])
    @user = User.find(params[:user])
    @group.users.delete @user

    redirect_to @group
  end



  private


  def group_params
    params.require(:group).permit(:name, :owner_id)
  end

#  student can still create group so we need a methd


end
