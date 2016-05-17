namespace :machine do
  include Aptitude
  include UserManagement

  desc "Sets up a blank Ubuntu to run our Rails-setup"
  task :init do
    on roles(:app) do
      apt_get_update
    end
    invoke "machine:install:ssh_keys"
    invoke "machine:install:htop"
    invoke "machine:install:language_pack_de"
    invoke "machine:install:cron_apt"
    invoke "machine:install:ntp"
    invoke "machine:install:git"
    invoke "machine:install:nginx"
    invoke "machine:install:fail2ban"
    invoke "machine:install:rvm"
    invoke "machine:install:ruby"
    invoke "machine:install:set_defaults"
    invoke "machine:install:bluepill"
    invoke "machine:install:bundler"
    invoke "machine:install:nodejs"
    invoke "machine:install:elasticsearch"
    invoke "machine:install:imagemagick" if fetch(:imagemagick)
    invoke "machine:install:memcached" if fetch(:memcached)
    invoke "machine:install:mysql_dev" if fetch(:db_engine) == "mysql"
    invoke "machine:install:postgres_dev" if fetch(:db_engine) == "postgresql"
  end
  before "machine:init", "machine:check_ubuntu_user"
  before "deploy", "machine:check_ubuntu_user"

  desc "Check if we are doing things as the correct user"
  task :check_ubuntu_user do
    on roles(:app) do
      unless am_i?("ubuntu")
        execute_script("create_ubuntu_user.sh") # Creates an Amazon AWS-style 'ubuntu'-user on machines with only 'root'
        error "Please use a use a user named 'ubuntu' to login to the machine."
        raise
      end
    end
  end

  desc "Install configs"
  task :setup do
    invoke "nginx:setup"
    invoke "unicorn:setup" if fetch(:app_server) == "unicorn"
    invoke "puma:setup" if fetch(:app_server) == "puma"
    invoke "upstart:setup"
    invoke "logrotate:setup"
    invoke "fail2ban:setup"
    invoke "bluepill:setup"
  end
  before :setup, "deploy:ensure_folder"

  desc "Install all dependencies"
  namespace :install do
    task :set_defaults do
      on roles(:app) do
        execute_script("set_defaults.sh", fetch(:rvm_ruby_version))
      end
    end

    task :elasticsearch do
      invoke 'elasticsearch:install'
    end

    task :language_pack_de do
      on roles(:app) do
        apt_get_install("language-pack-de") unless package_installed?("language-pack-de")
      end
    end

    task :ruby do
      on roles(:app) do
        execute :rvm, :install, fetch(:rvm_ruby_version)
      end
    end
    before :ruby, 'rvm:hook'

    task :bundler do
      on roles(:app) do
        execute :rvmsudo, :gem, :install, :bundler
      end
    end
    before :bundler, 'rvm:hook'

    task :bluepill do
      on roles(:app) do
        execute :rvmsudo, :gem, :install, :bluepill
        sudo 'mkdir -p /var/run/bluepill'
      end
    end
    before :bluepill, 'rvm:hook'

    task :rvm do
      on roles(:app) do
        execute_script("install_rvm.sh")
      end
    end

    task :imagemagick do
      on roles(:app) do
        apt_get_install("imagemagick") unless package_installed?("imagemagick")
      end
    end

    task :memcached do
      on roles(:app) do
        apt_get_install("memcached") unless package_installed?("memcached")
      end
    end

    task :mysql_dev do
      on roles(:app) do
        apt_get_install("libmysqlclient-dev") unless package_installed?("libmysqlclient-dev")
      end
    end

    task :postgres_dev do
      on roles(:app) do
        apt_get_install("libpq-dev") unless package_installed?("libpq-dev")
        apt_get_install("postgresql-client") unless package_installed?("postgresql-client")
      end
    end

    task :htop do
      on roles(:app) do
        apt_get_install("htop") unless package_installed?("htop")
      end
    end

    task :nodejs do
      on roles(:app) do
        apt_get_install("nodejs") unless package_installed?("nodejs")
      end
    end

    task :ntp do
      on roles(:app) do
        apt_get_install("ntp") unless package_installed?("ntp")
        sudo "chmod 666 /etc/timezone"
        execute 'echo "Europe/Berlin" > /etc/timezone'
        sudo "chmod 644 /etc/timezone"
        sudo "dpkg-reconfigure -f noninteractive tzdata"
      end
    end

    task :git do
      on roles(:app) do
        apt_get_install("git") unless package_installed?("git")
      end
    end

    task :nginx do
      on roles(:app) do
        apt_get_install("nginx") unless package_installed?("nginx")
      end
    end

    task :fail2ban do
      on roles(:app) do
        apt_get_install("fail2ban") unless package_installed?("fail2ban")
      end
    end

    task :imagemagick do
      on roles(:app) do
        unless package_installed?("imagemagick")
          apt_get_install("imagemagick")
          apt_get_install("libmagickcore-dev")
          apt_get_install("libmagickwand-dev")
        end
      end
    end

    task :cron_apt do
      on roles(:app) do
        apt_get_install("cron-apt") unless is_package_installed?("cron-apt")

        template "security_sources_list.erb", "/tmp/security_sources_list"
        sudo "mv /tmp/security_sources_list /etc/apt/security.sources.list"
        sudo "chmod 644 /etc/apt/security.sources.list"

        template "security_upgrades.erb", "/tmp/security_upgrades"
        sudo "mv /tmp/security_upgrades /etc/cron-apt/action.d/5-security"
        sudo "chmod 644 /etc/cron-apt/action.d/5-security"
      end
    end

    desc "Installs new SSH Keys"
    task :ssh_keys do
      on roles(:app) do
        file_patterns = fetch(:ssh_file_names)

        next puts("Skip SSH key installation") if file_patterns == []

        puts "Installing SSH Keys from #{file_patterns.join(',')}..."

        keys = []
        file_patterns.each do |file_pattern|
          Dir.glob(File.expand_path(file_pattern)).each do |file_name|
            next if File.directory?(file_name)
            key_as_string = File.read(file_name)

            if key_as_string.start_with?("ssh-rsa")
              keys << key_as_string
              puts file_name
            else
              warn "#{file_name} is NO publickey"
            end
          end
        end

        raise "No ssh-keys found in #{file_patterns.join(',')}." unless keys.any?

        upload!(StringIO.new(keys.join("")), 'new_keys')
        sudo "rm ~/.ssh/authorized_keys"
        sudo "mv new_keys ~/.ssh/authorized_keys"
      end
    end

    task :update_rvm_key do
      on roles(:app) do
        execute :gpg, "--keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3"
      end
    end
    before "machine:install:rvm", "machine:install:update_rvm_key"
  end
end
