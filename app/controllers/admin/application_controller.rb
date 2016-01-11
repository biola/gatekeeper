class Admin::ApplicationController < ::Gatekeeper::ApplicationController
  before_action :authenticate!

  layout 'admin'

  helper_method :search_path

  def current_user
    @current_user ||= Admin::CurrentUserPresenter.new(session)
  end

  protected

  def authenticate!
    render_error_page(401) unless current_user.authenticated?
  end
end
