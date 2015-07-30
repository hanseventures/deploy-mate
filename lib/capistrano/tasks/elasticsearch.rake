set_default(:elasticsearch_version, "1.7")

namespace :elasticsearch do
  include Aptitude
  task :install do
    on roles(:search) do
      unless is_package_installed?("elasticsearch")
        apt_get_install("openjdk-7-jre-headless") unless is_package_installed?("openjdk-7-jre-headless")
        execute "wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -"
        sudo "add-apt-repository 'deb http://packages.elasticsearch.org/elasticsearch/#{fetch(:elasticsearch_version)}/debian stable main'"
        apt_get_update
        apt_get_install("elasticsearch")
        sudo "update-rc.d elasticsearch defaults 95 10"
        sudo :service, :elasticsearch, :start
      end
    end
  end
end
