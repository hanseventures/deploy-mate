module Bluepill
  def bluepill_running?
    /running/.match(capture(:status, :bluepill))
  end

  def pill_running?(pill_name)
    /up/.match(capture(:rvmsudo, :bluepill, :status, pill_name))
  end
end
