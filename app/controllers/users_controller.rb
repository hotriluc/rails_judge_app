class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :teacher_user, only: [:new,:create_student, :edit, :destroy]


  def show
    @user = User.find(params[:id])
  end

  # creating new student
  def new
    @user = User.new

  end

  def create_student

    puts "Create start==============="
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path
    #  do something
    else
      render 'users/new'
    end

  end


  # edit student
  def edit


  end

  # destroy student
  def destroy


  end


  private

  # if current user is teacher he can create edit destroy users
  def teacher_user
    redirect_to(root_url) unless current_user.teacher?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user == @user
  end

  # required params for created users
  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end

end
