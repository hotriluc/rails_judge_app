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
    # puts "Create start==============="

    #Creating new user with required params
    @user = User.new(user_params)

    #After saving redirect to current user (the one who is in session)
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

    # p '=================================='
    # p user_params
    # p params[:user][:password].empty?
    # p '==========='

    #Check if password in params is empty
    # if it is then we will send hash user_params without password and password confirmation
    # if params[:user][:password].empty?
    #   edit_user_params = user_params.except("password","password_confirmation")
    # else
    #   edit_user_params  = user_params
    # end

    # using the ternary operator the same as commented above code
    edit_user_params =  params[:user][:password].empty? ? user_params.except("password","password_confirmation") : user_params


    if @user.update_attributes(edit_user_params)
      flash[:success] = "Profile updated"
      redirect_to current_user
    else
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
      redirect_to(current_user)
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
