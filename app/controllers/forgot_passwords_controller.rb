class ForgotPasswordsController < Gatekeeper::ApplicationController
  def new
    authorize nil
  end

  def create
    authorize nil

    if user = User.active.where(email: params[:email]).first
      # TODO: The gsub shouldn't be necessary once verison > 0.0.2 of Madgab is released
      password = Madgab.generate.gsub '_', ' '

      user.update! password: password

      UserMailer.password_reset(user, password).deliver_now

      redirect_to root_url, notice: 'Your password has been reset. Please check your inbox.'
    else
      redirect_to forgot_password_path, alert: 'No user account with that email was found'
    end
  end

  private

  def policy(_)
    ForgotPasswordPolicy.new(current_user, nil)
  end
end
