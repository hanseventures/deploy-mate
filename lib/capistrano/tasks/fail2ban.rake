namespace :fail2ban do
  include Shell

  desc "Restart fail2ban"
  task :restart do
    on roles(:web) do
      sudo "service fail2ban restart"
    end
  end

end
