namespace :logrotate do
  include Shell

  desc "Install the logrotate config"
  task :setup do
    on roles(:app) do
      template "logrotate.erb", "/tmp/logrotate-#{fetch(:application)}"
      sudo "mv /tmp/logrotate-#{fetch(:application)} /etc/logrotate.d/#{fetch(:application)}"
      sudo "chown root:root /etc/logrotate.d/#{fetch(:application)}"
    end
  end

end
