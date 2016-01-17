ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/email/rspec'

Dir[Rails.root.join('spec/support/*.rb')].each {|f| require f}

Mongoid.load!('spec/config/mongoid.yml')

Capybara.asset_host = URI::HTTP.build(scheme: 'http', host: Settings.app.host).to_s

RSpec.configure do |config|
  config.include Mongoid::Matchers, type: :model
  config.infer_spec_type_from_file_location!

  config.before(:each) do
    config.include FactoryGirl::Syntax::Methods

    Mongoid.default_client.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end
