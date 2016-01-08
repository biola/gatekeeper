class Admin::ApplicationController < ::Gatekeeper::ApplicationController
  before_action :authenticate!

  def current_user
    @current_user ||= Admin::CurrentUserPresenter.new(session)
  end

  def title
    "#{Settings.app.name} Admin"
  end

  def title_url
    admin_root_url
  end

  def subtitle
    'Manage non-biolan user accounts'
  end

  protected

  def authenticate!
    render_error_page(401) unless current_user.authenticated?
  end
end
