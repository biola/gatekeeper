class UserMailer < ApplicationMailer
  def email_confirmation(user)
    @user = user
    mail to: @user.email, subject: 'Please confirm your email address'
  end

  def password_reset(forgot_password)
    @forgot_password = forgot_password
    @user = forgot_password.non_biolan
    mail to: @user.email, subject: 'Your password reset link'
  end
end
