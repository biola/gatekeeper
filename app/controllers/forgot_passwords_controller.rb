class ForgotPasswordsController < ApplicationController
  include Session

  def new
    authorize nil
  end

  def create
    authorize nil

    if user = NonBiolan.where(email: params[:email]).first
      forgot_password = ForgotPassword.create! non_biolan: user

      UserMailer.password_reset(forgot_password).deliver_now

      redirect_to root_url, notice: 'Your password reset link has been sent. Please check your inbox.'
    else
      redirect_to new_forgot_password_path, alert: 'No user account with that email was found'
    end
  end

  def edit
    @forgot_password = ForgotPassword.active.find_by(key: params[:id])

    authorize @forgot_password
  end

  def update
    @forgot_password = ForgotPassword.active.find_by(key: params[:id])
    @user = @forgot_password.non_biolan

    authorize @forgot_password

    if @user.update user_params
      login! @user
      @forgot_password.update! used: true
      redirect_to edit_user_path, notice: 'Your password has been changed'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:non_biolan).permit :password, :password_confirmation
  end

  def policy(_)
    ForgotPasswordPolicy.new(current_user, nil)
  end
end
