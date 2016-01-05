Rails.application.config.action_mailer.tap do |cfg|
  cfg.default_url_options = {host: Settings.app.host}

  cfg.smtp_settings = {address: Settings.email.smtp.server}
end
