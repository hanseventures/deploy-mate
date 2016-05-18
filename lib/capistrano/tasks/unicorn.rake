set_default(:unicorn_workers, "5")
set_default(:unicorn_timeout, "30")
set_default(:unicorn_worker_grace_time, "60")

namespace :unicorn do
  include Bluepill
  include Shell

  desc "Installs the unicorn config"
  task :setup do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      if file_new_or_overwrite?("#{shared_path}/config/unicorn.rb")
        template "unicorn.rb.erb", "#{shared_path}/config/unicorn.rb"
      end
    end
  end
end
