class GroupsController < ApplicationController


  def new
    @group = Group.new
  end

  def create

    p '===================='
    p group_params
    p params
    p '===================='

    @group = Group.new(group_params)

    p '===================='
    p @group
    p '===================='

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



  private


  def group_params
    params.require(:group).permit(:name)
  end




end
