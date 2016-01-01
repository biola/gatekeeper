module Session
  extend ActiveSupport::Concern

  def logout!
    session[:user_id] = nil
    # TODO: check for and handle cas authentication
  end
end
