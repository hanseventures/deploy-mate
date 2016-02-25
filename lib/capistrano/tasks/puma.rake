set_default(:puma_workers, "5")
set_default(:puma_threads, "10")
set_default(:puma_timeout, "30")
set_default(:puma_worker_grace_time, "60")

namespace :puma do
  include Bluepill
  include Shell

  desc "Installs the puma config"
  task :setup do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      if file_new_or_overwrite?("#{shared_path}/config/puma.rb")
        template "puma.rb.erb", "#{shared_path}/config/puma.rb"
      end
    end
  end

end
