module LinkHelper
  def cas_login_url(service_url = nil)
    service_url ||= request.url
    RackCAS::Server.new(RackCAS.config.server_url).login_url(service_url).to_s
  end
end
