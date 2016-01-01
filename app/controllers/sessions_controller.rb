class SessionsController < ApplicationController
  include Session

  def create
    user = User.active.where(email: session_params[:email]).first

    if user && user.authenticate(session_params[:password])
      login! user
      redirect_to user_path, notice: "You've been logged in"
    else
      flash[:login_email] = session_params[:email]
      redirect_to new_user_path, alert: "Invalid email or password"
    end
  end

  def destroy
    logout!
    redirect_to root_url, notice: "You've been logged out"
  end

  private

  def session_params
    params.require(:session).permit :email, :password
  end
end