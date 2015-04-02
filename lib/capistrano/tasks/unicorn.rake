set_default(:unicorn_workers, "5")
set_default(:unicorn_timeout, "30")
set_default(:unicorn_worker_grace_time, "60")

namespace :unicorn do
  include Bluepill

  desc "Installs the unicorn config"
  task :setup do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      template "unicorn.rb.erb", "#{shared_path}/config/unicorn.rb"
    end
  end

  desc "Gracefully restarts unicorn"
  task :phased_restart do
    on roles(:app) do
      if bluepill_running?
        if pill_running?(:unicorn)
          execute :rvmsudo, :bluepill, :restart, :unicorn
        else
          execute :rvmsudo, :bluepill, :start, :unicorn
        end
      else
        invoke "bluepill:start"
        invoke "nginx:reload"
      end
    end
  end
  before :phased_restart, 'rvm:hook'

end
