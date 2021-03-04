class TaskMailer < ApplicationMailer


  def task_create_notification(subject, user, group, task)
    @user = user
    @task = task
    @group = group


    mail(to: @user.email, subject: subject)
  end


end
