module ApplicationHelper



  def full_title(page_title="")
    base_title = "Judge app"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end


  #3 methods bellow
  # to get access to resource(user) when add devise login form on home page
  def resource_name
      :user
  end

  def resource
      @resource ||= User.new
  end

  def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
  end


  #====BEFORE FILTERS====

  # if current user is teacher he can create edit destroy users
  def teacher_user
    unless current_user.teacher?
      flash[:danger] = "You don't have permission to do this"
      redirect_to(current_user)
    end

    # redirect_to(root_url) unless current_user.teacher?
  end

  #check if current user is teacher and owner of the group
  # if he is then can do something
  def correct_owner
    @group = Group.find(params[:id])
    @owner = User.find(@group.owner_id)

    unless current_user == @owner
      flash[:danger] = "You don't have permission to do this"
      redirect_to root_url
    end
  end



end
