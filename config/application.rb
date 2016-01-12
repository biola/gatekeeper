require File.expand_path('../boot', __FILE__)

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module Gatekeeper
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/app/presenters)
    config.time_zone = 'Pacific Time (US & Canada)'
  end
end
