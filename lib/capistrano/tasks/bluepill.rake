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

  desc "Stops unicorn"
  task :stop do
    on roles(:app) do
      sudo "stop bluepill"
    end
  end


end

