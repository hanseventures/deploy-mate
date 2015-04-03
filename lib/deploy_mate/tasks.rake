require 'readline'

namespace :deploy_mate do

  desc 'Installs the needed capistrano files to deploy with the mate.'
  task :install do |t,args|
    puts "Greetings, landlubber! I'm your DEPLOY_MATE."
    puts "We be setting up yer d'ployment now."

    @app_name = ask("Name (for nginx, servers, etc.):", guess_app_name)
    @repo_url = ask("Location of yer git-repo:", "git@github.com:hanseventures/#{@app_name}.git")
    @is_rails = yes_or_no?("Is this a RAILS project", (rails_present? ? "yes" : "no"))

    @stage_name = ask("Give your firrst stage a name:", "prestage")
    @ssh_name = ask("Houw can I rreach the server with SSH:", "#{@app_name}-#{@stage_name}")
    @branch_name = ask("Which brrranch does '#{@stage_name}' d'ploy frem:", "dev")
    @hostname = ask("Give '#{@stage_name}' a host-name (for nginx):", "#{@stage_name}.#{@app_name}.com")
    @environment = ask("What is the name of #{@stage_name}'s environment:", "#{@stage_name}")

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