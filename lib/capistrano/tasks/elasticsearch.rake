namespace :elasticsearch do
  include Aptitude
  task :install do
    on roles(:search) do
      apt_get_install("openjdk-7-jre-headless") unless is_package_installed?("openjdk-7-jre-headless")
      execute "wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -"
      sudo 'add-apt-repository "deb http://packages.elasticsearch.org/elasticsearch/1.5/debian stable main"'
      apt_get_update
      apt_get_install("elasticsearch") unless is_package_installed?("elasticsearch")
      sudo "update-rc.d elasticsearch defaults 95 10"
      sudo :service, :elasticsearch, :start
    end
  end
end