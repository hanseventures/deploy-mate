if defined?(Rails)
  module DeployMate
    class Railtie < Rails::Railtie
      rake_tasks do
        load 'deploy_mate/tasks.rake'
      end
    end
  end
end
