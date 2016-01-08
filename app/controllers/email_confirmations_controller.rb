class EmailConfirmationsController < Gatekeeper::ApplicationController
  include Session

  def confirm
    @user = User.where(confirmation_key: params[:key]).first

    authorize @user

    if @user.nil?
      flash.now.alert = 'Could not confirm your email address. Invalid confirmation key.'
    elsif @user.confirmed?
      flash.now.alert = 'Your email address has already been confirmed.'
    else
      @user.update! confirmed: true
      login! @user
      flash.now.notice = "Your email address #{@user.email} has been confirmed."

      if session[:return_url].present?
        @return_url = session.delete(:return_url)
      end
    end
  end

  def resend
    authorize current_user
    UserMailer.email_confirmation(current_user).deliver_now
    redirect_to user_path, notice: "Password confirmation sent to #{current_user.email}"
  end

  private

  def policy(user)
    EmailConfirmationPolicy.new(current_user, user)
  end
end
