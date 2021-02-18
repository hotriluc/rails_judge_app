class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :teacher_user, only: [:new,:create_student, :edit, :update, :destroy]


  def show
    @user = User.find(params[:id])
  end

  # creating new student
  def new
    @user = User.new
  end


  # custom create post method to avoid conflict between devise UserRegistrationController create
  # and User Controller create
  def create_student
    puts "Create start==============="
    @user = User.new(user_params)

    if @user.save
      redirect_to user_path(current_user)
    #  do something
    else
      render 'users/new'
    end

  end


  # edit student
  def edit
    @user = User.find(params[:id])
  end

  def update



    @user = User.find(params[:id])




    # if params[:password].empty?
    #   @user.update_attributes()
    # end

    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to root_path
    else
      # puts '============'
      # puts params[:password].blank?
      # puts '========='
      #
      # # if params[:password.blank?]
      # #   @user.update_attributes(name: params[:name], email: params[:email])
      # # end

      render 'edit'
    end
  end

  # destroy student
  def destroy


  end


  private

  # if current user is teacher he can create edit destroy users
  def teacher_user
    unless current_user.teacher?
      flash[:alert] = "You don't have permission to do this"
      redirect_to(root_url)
    end

    # redirect_to(root_url) unless current_user.teacher?
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
