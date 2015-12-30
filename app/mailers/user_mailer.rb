class UserMailer < ApplicationMailer
  def email_confirmation(user)
    @user = user
    mail to: @user.email, subject: 'Please confirm your email address'
  end
end
