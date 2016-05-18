module Aptitude
  def apt_get_update
    sudo "apt-get -y update"
  end

  def apt_get_install(package_name)
    sudo "apt-get -y install #{package_name}"
  end

  def apt_get_remove(package_name)
    sudo "sudo apt-get -y autoremove #{package_name}"
  end

  def package_installed?(package_name)
    !/(Installed: \(none\)|Unable to locate package)/.match(capture("apt-cache policy #{package_name}"))
  end
end
