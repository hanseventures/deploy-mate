namespace :fail2ban do
  include Shell

  desc "Installs the fail2ban configs"
  task :setup do
    on roles(:web) do
      if file_new_or_overwrite?("/etc/fail2ban/jail.conf")
        template "fail2ban-nginx-request-limit-jail.conf.erb", "/tmp/fail2ban_jail"
        sudo "mv /tmp/fail2ban_jail /etc/fail2ban/jail.conf"
      end
      if file_new_or_overwrite?("/etc/fail2ban/filter.d/nginx-req-limit.conf")
        template "fail2ban-nginx-request-limit-jail.conf.erb", "/tmp/fail2ban_req_filter"
        sudo "mv /tmp/fail2ban_req_filter /etc/fail2ban/filter.d/nginx-req-limit.conf"
      end
    end
  end

  desc "Restart fail2ban"
  task :restart do
    on roles(:web) do
      sudo "service fail2ban restart"
    end
  end

  after "fail2ban:setup", "fail2ban:restart"
end
