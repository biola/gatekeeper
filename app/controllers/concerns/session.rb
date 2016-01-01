module Session
  extend ActiveSupport::Concern

  def login!(user)
    session[:user_id] = user.id.to_s
  end

  def logout!
    session[:user_id] = nil
    # TODO: check for and handle cas authentication
  end
end
