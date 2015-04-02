# This file contains default values for all projects
set :log_level, :info

set :user, "ubuntu"
set :group, "www-data"

set :pty, true
set :rvm_ruby_version, "ruby-2.2.0"
set :rvm_map_bins, %w{gem rake ruby rvmsudo bundle}

set :deploy_to, "/srv/#{fetch(:application)}"
set :linked_dirs, %w{bin log vendor/bundle system/pids system/sockets public/assets}

set :keep_releases, 3
set :ssh_options, { forward_agent: true }

# bundler config
set :bundle_flags, "--deployment"
set :bundle_without, %w{development test}.join(' ')
set :bundle_exec, "bundle exec"

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke "unicorn:phased_restart"
    end
  end

  desc 'Ensure that the app folder is present'
  task :ensure_folder do
    on roles(:app) do
      sudo :mkdir, '-p', fetch(:deploy_to)
      sudo :chown, "#{fetch(:user)}:#{fetch(:group)}", fetch(:deploy_to)
    end
  end

  desc 'Set app folder user:group permissions'
  task :set_permissions do
    on roles(:app) do
      sudo :chown, '-R', "#{fetch(:user)}:#{fetch(:group)}", fetch(:deploy_to)
    end
  end

  after :publishing, :restart
  before :check, :ensure_folder
  before :check, :set_permissions
end
