namespace :upstart do
  include Upstart
  include Shell

  # TODO: remove one of these - they do the same
  desc "Install the upstart config"
  task :setup do
    on roles(:app) do
      if file_new_or_overwrite?("/etc/init/bluepill.conf")
        template "upstart.conf.erb", "/tmp/bluepill.conf"
        sudo "mv /tmp/bluepill.conf /etc/init/"
      end
      sudo "chown root:root /etc/init/bluepill.conf"
    end
  end

  task :start do
    on roles(:app) do
      if file_new_or_overwrite?("/etc/init/bluepill.conf")
        template "upstart.conf.erb", "/tmp/bluepill.conf"
        sudo "mv /tmp/bluepill.conf /etc/init/"
      end
      sudo "chown root:root /etc/init/bluepill.conf"
    end
  end

end
