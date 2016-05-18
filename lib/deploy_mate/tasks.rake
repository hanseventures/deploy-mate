namespace :deploy_mate do
  desc 'copy the default configuration file to config/deploy_mate.yml'
  task :default_config do
    @app_name     = guess_app_name
    @ruby_version = guess_ruby_version
    @rails        = to_h(rails?)
    @imagemagick  = to_h(imagemagick?)
    @sidekiq      = to_h(sidekiq?)
    @memcached    = to_h(memcached?)

    puts "Creating default template:\n\n"
    puts "\t" + config_template('deploy_mate.yml.erb', 'config/deploy_mate.yml')
    puts "\nConfigure it and then run:\n\n\tbundle exec rake deploy_mate:install\n\n"
  end

  task :install do
    @config = YAML.load_file(File.expand_path('config/deploy_mate.yml', ENV['PWD']))
    puts "Creating capistrano deployment files:\n"
    FileUtils.mkdir_p("config/deploy") unless File.exist?("config/deploy")
    puts config_template("Capfile.erb", "Capfile")
    puts config_template("deploy.rb.erb", "config/deploy.rb")
    puts config_template("deploy/stage.rb.erb", "config/deploy/#{@config['stage_name']}.rb")
  end
end

def config_template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  compiled = ERB.new(erb).result(binding)
  File.open(to, "wb") { |f| f.write(compiled) }
  to
end

def sidekiq?
  defined? Sidekiq
end

def imagemagick?
  defined? RMagick || defined? MiniMagick
end

def memcached?
  defined? Dalli
end

def rails?
  defined? Rails
end

def guess_app_name
  Dir.pwd.split(File::SEPARATOR).last
end

def guess_ruby_version
  ruby_version = cat_file(".ruby-version")
  ruby_version.strip! if ruby_version
  unless ruby_version
    gem_file_content = cat_file("Gemfile")
    if gem_file_content
      match = gem_file_content.match("^ruby '(?<version>[0-9.]*)'")
      ruby_version = "ruby-" + match["version"] if match
    end
  end
  ruby_version
end

def to_h(value)
  value ? "yes" : "no"
end

def cat_file(filename)
  File.open(filename, "rb", &:read) if File.exist?(filename)
end
