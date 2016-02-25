namespace :bluepill do

  desc "Installs the application pill"
  task :setup do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      template "application.pill.erb", "#{shared_path}/config/#{fetch(:application)}.pill"
    end
  end

  desc "Starts bluepill"
  task :start do
    on roles(:app) do
      if !bluepill_running?
        sudo "start bluepill"
      else
        info "No need to start bluepill, it is running!"
      end
    end
  end

  desc "Stops app server"
  task :stop do
    on roles(:app) do
      if bluepill_running?
        sudo "stop bluepill"
      else
        "Can't stop bluepill because it's not running!"
      end
    end
  end

  desc "Restarts/Reloads app gracefully"
  task :restart do
    invoke "bluepill:start"

    on roles(:app) do
      if bluepill_running?
        if pill_running?(fetch(:app_server))
          execute :rvmsudo, :bluepill, fetch(:application), :restart
        else
          execute :rvmsudo, :bluepill, fetch(:application), :start
        end
      end
    end

    invoke "nginx:reload"
  end
  before :restart, 'rvm:hook'
end
