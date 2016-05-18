set_default(:nginx_server_name, "*.*")

namespace :nginx do
  include Shell

  desc "Installs the nginx configs"
  task :setup do
    on roles(:web) do
      if file_new_or_overwrite?("/etc/nginx/nginx.conf")
        template "nginx_base.conf.erb", "/tmp/nginx_conf"
        sudo "mv /tmp/nginx_conf /etc/nginx/nginx.conf"
      end

      if file_new_or_overwrite?("/etc/nginx/sites-available/#{fetch(:application)}.conf")
        template "nginx_app.conf.erb", "/tmp/#{fetch(:application)}_conf"
        sudo "mv /tmp/#{fetch(:application)}_conf /etc/nginx/sites-available/#{fetch(:application)}.conf"
      end

      if file_exists? "/etc/nginx/sites-enabled/default"
        sudo "rm /etc/nginx/sites-enabled/default"
      end

      execute "mkdir -p #{shared_path}/log"
    end
    invoke "nginx:enable_site"
    invoke "nginx:reload"
  end

  desc "Enable the app page for nginx"
  task :enable_site do
    on roles(:web) do
      unless file_exists? "/etc/nginx/sites-enabled/#{fetch(:application)}.conf"
        sudo "ln -sf /etc/nginx/sites-available/#{fetch(:application)}.conf /etc/nginx/sites-enabled/#{fetch(:application)}.conf"
      end
    end
  end

  desc "Reload nginx"
  task :reload do
    on roles(:web) do
      sudo "service nginx reload"
    end
  end

  desc "Restart nginx"
  task :restart do
    on roles(:web) do
      sudo "service nginx restart"
    end
  end

  desc "Stop nginx"
  task :stop do
    on roles(:web) do
      sudo "service nginx stop"
    end
  end

  desc "Start nginx"
  task :start do
    on roles(:web) do
      sudo "service nginx start"
    end
  end

  desc "Installs the ssl certificates"
  task :ssl do
    on roles(:web) do
      sudo "mkdir -p /etc/nginx/ssl"
      sudo "chmod 770 /etc/nginx/ssl"
      sudo "chown #{fetch(:user)}:#{fetch(:group)} /etc/nginx/ssl"

      %w(crt key).each do |type|
        upload! "vendor/certs/#{fetch(:application)}.de.#{type}", "/etc/nginx/ssl/#{fetch(:application)}.de.#{type}"
      end
    end
  end

  after "nginx:setup", "nginx:reload"
end
