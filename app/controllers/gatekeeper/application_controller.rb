class Gatekeeper::ApplicationController < ActionController::Base
  include Pundit

  layout 'gatekeeper'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  helper_method :current_user
  def current_user
    @user ||= User.where(id: session[:user_id]).first if session[:user_id].present?
  end

  helper_method :title
  def title
    Settings.app.name
  end

  helper_method :title_url
  def title_url
    root_url
  end

  helper_method :subtitle
  def subtitle
    'Manage your Biola University account'
  end

  protected

  def render_error_page(status)
    render file: "#{Rails.root}/public/#{status}", formats: [:html], status: status, layout: false
  end

  def user_not_authorized
    render_error_page(403)
  end
end
