require 'readline'

namespace :deploy_mate do

  desc 'Installs the needed capistrano files to deploy with the mate.'
  task :install do |t,args|
    puts "I'm your DEPLOY_MATE."
    puts "We will setting up your deployment now."

    @app_name = ask("App-Name (for nginx, servers, etc.):", guess_app_name)
    @repo_url = ask("Url-Location of git-repo:", "git@github.com:hanseventures/#{@app_name}.git")
    @is_rails = yes_or_no?("Is this a RAILS project ?", (rails_present? ? "yes" : "no"))

    @stage_name = ask("Give the first stage a name:", "prestage")
    @ssh_name = ask("SSH-Hostname for the server:", "#{@app_name}-#{@stage_name}")
    @branch_name = ask("Branch to deploy '#{@stage_name}' from:", "dev")
    @host_name = ask("Web-URL for '#{@stage_name}':", "#{@stage_name}.#{@app_name}.com")
    @environment = ask("#{@stage_name}'s environment (RACK_ENV/RAILS_ENV):", "#{@stage_name}")
    @db_engine = ask_until("What db are you using?", %w( postgresql mysql ), "mysql")

    puts "Aye!"
    puts "Worrrrking..."

    config_template("Capfile.erb", "Capfile")
    sleep 1
    config_template("deploy.rb.erb", "config/deploy.rb")
    sleep 1
    FileUtils.mkdir_p("config/deploy") unless File.exists?("config/deploy")
    config_template("deploy/stage.rb.erb", "config/deploy/#{@stage_name}.rb")
    sleep 1

    puts "Arr, be dun working!"
  end

end

def config_template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  compiled = ERB.new(erb).result(binding)
  File.open(to, "wb") { |f| f.write(compiled) }
  puts "'#{to}'"
end

def rails_present?
  defined? Rails
end

def guess_app_name
  Dir.pwd.split(File::SEPARATOR).last
end

def yes_or_no?(prompt, default = nil)
  answer = "undefined"
  while(!["yes", "no"].include?(answer))
    answer = ask("#{prompt} [yes/no]:", (default == "yes" ? "yes" : "no"))
  end
  (answer == "yes")
end

def ask_until(prompt, answers, default)
  begin
    answer = ask("#{prompt} (#{answers.join(', ')})", default).downcase
  end until answers.include? answer
  answer
end

def ask(prompt, default = nil)
  if default
    Readline.pre_input_hook = -> {
      Readline.insert_text(default)
      Readline.redisplay
    }
  end
  data = Readline.readline("#{prompt}: ")
  return data.chomp
end
