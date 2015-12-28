# By default CASino::ApplicationController inherits from ApplicationController
# and uses the applicatoin layout. But we want to isolate it. So we're
# overriding that behaviour.
class CASino::ApplicationController < ActionController::Base
  layout 'casino'

  unless Rails.env.development?
    rescue_from ActionView::MissingTemplate, with: :missing_template
  end

  def cookies
    super
  end

  protected
  def missing_template(exception)
    render plain: 'Format not supported', status: :not_acceptable
  end
end
