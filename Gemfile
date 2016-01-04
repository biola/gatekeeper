source 'https://rubygems.org'

gem 'rails', '4.2.5'

# For CASino support
gem 'casino'
# The Github repo is just temporary until this PR gets merged https://github.com/digitalnatives/casino-moped_authenticator/pull/3
gem 'casino-moped_authenticator', github: 'adamcrown/casino-moped_authenticator', ref: 'patch-1'
gem 'sqlite3'

gem 'bcrypt', '~> 3.1.7'
gem 'biola_frontend_toolkit'
gem 'biola_logs'
gem 'coffee-rails', '~> 4.1.0'
gem 'config'
gem 'jquery-rails'
gem 'madgab'
gem 'mongoid'
gem 'newrelic_rpm'
gem 'pundit'
gem 'rack-cas'
gem 'rack-ssl'
gem 'sass-rails', '~> 5.0'
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug'
end

group :development do
  gem 'better_errors'
  gem 'letter_opener'
  gem 'pry'
  gem 'spring'
  gem 'web-console', '~> 2.0'
end

group :production do
  gem 'turnout'
  gem 'sentry-raven'
end
