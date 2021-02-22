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



end
