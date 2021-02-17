class UsersController < ApplicationController
  before_action :authenticate_user!
  # before_action :teacher_user, only: [:new,:create, :edit, :destroy]


  def show
    @user = User.find(params[:id])
  end

  # creating new student
  def new
    @user = User.new

  end

  def create


  end


  # edit student
  def edit


  end

  # destroy student
  def destroy


  end


  protected

  # if current user is teacher he can create edit destroy users
  def teacher_user
    redirect_to(root_url) unless current_user.teacher?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user == @user

  end

end
