module Upstart
  def service_running?(service)
    /running/.match(capture("status #{service}"))
  end
end
