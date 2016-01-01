class UserMailer < ApplicationMailer
  def email_confirmation(user)
    @user = user
    mail to: @user.email, subject: 'Please confirm your email address'
  end

  def password_reset(user, password)
    @user = user
    @password = password
    mail to: @user.email, subject: 'Your password has been reset'
  end
end
