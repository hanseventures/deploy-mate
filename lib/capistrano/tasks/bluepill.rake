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
      sudo "start bluepill"
    end
  end

  desc "Stops app server"
  task :stop do
    on roles(:app) do
      sudo "stop bluepill"
    end
  end

  desc "Restarts/Reloads app gracefully"
  task :restart do
    on roles(:app) do
      if bluepill_running?
        if pill_running?(fetch(:app_server))
          execute :rvmsudo, :bluepill, fetch(:application), :restart
        else
          execute :rvmsudo, :bluepill, fetch(:application), :start
        end
      else
        invoke "bluepill:start"
        invoke "nginx:reload"
      end
    end
  end
  before :restart, 'rvm:hook'
end
