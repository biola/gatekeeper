TrogdirAPIClient.configure do |config|
  config.scheme = Settings.trogdir.scheme
  config.host = Settings.trogdir.host
  config.port = Settings.trogdir.port
  config.script_name = Settings.trogdir.script_name
  config.version = Settings.trogdir.version
  config.access_id = Settings.trogdir.access_id
  config.secret_key = Settings.trogdir.secret_key
end
