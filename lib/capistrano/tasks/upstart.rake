namespace :upstart do
  include Upstart
  include Shell

  # TODO: remove one of these - they do the same
  desc "Install the upstart config"
  task :setup do
    on roles(:app) do
      template "upstart.conf.erb", "/tmp/bluepill.conf"
      sudo "mv /tmp/bluepill.conf /etc/init/"
      sudo "chown root:root /etc/init/bluepill.conf"
    end
  end

  task :start do
    on roles(:app) do
      template "upstart.conf.erb", "/tmp/bluepill.conf"
      sudo "mv /tmp/bluepill.conf /etc/init/"
      sudo "chown root:root /etc/init/bluepill.conf"
    end
  end

end
