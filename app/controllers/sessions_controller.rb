class SessionsController < Gatekeeper::ApplicationController
  include Session

  def create
    authorize session

    user = User.where(username: session_params[:username]).first

    if user && user.authenticate(session_params[:password])
      login! user
      redirect_to user_path, notice: "You've been logged in"
    else
      flash[:login_username] = session_params[:username]
      redirect_to new_user_path, alert: "Invalid username or password"
    end
  end

  def destroy
    authorize session
    logout!
    redirect_to root_url, notice: "You've been logged out"
  end

  private

  def session_params
    params.require(:session).permit :username, :password
  end

  def policy(order)
    SessionPolicy.new(current_user, session)
  end
end
