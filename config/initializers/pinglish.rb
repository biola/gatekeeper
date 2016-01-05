Gatekeeper::Application.config.middleware.use Pinglish do |ping|
  ping.check :mongodb do
    Mongoid.default_client.command(ping: 1).documents.any?{|d| d == {'ok' => 1}}
  end

  ping.check :smtp do
    smtp = Net::SMTP.new(ActionMailer::Base.smtp_settings[:address])
    smtp.start
    ok = smtp.started?
    smtp.finish

    ok
  end
end
