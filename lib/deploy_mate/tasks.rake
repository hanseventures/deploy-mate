namespace :deploy_mate do

  desc 'Check rails present?'
  task :rails do |t,args|
    if defined? Rails
      puts "rails present"
    else
      puts "rails not present"
    end
  end

  desc 'Installs the needed capistrano files to deploy with the mate.'
  task :install do |t,args|
    puts deploy_mate_face
    puts "Greetings, landlubber!"
    puts "We be setting up yer d'ployment now."
    print "Give yer application a name: [application] "
    @app_name = STDIN.gets.strip
    @app_name = "application" if @app_name.blank?

    print "Give your firrst stage a name: [prestage] "
    @stage_name = STDIN.gets.strip
    @stage_name = "prestage" if @stage_name.blank?

    print "Houw can I rreach the server with SSH: [#{@app_name}-#{@stage_name}] "
    @ssh_name = STDIN.gets.strip
    @ssh_name = "#{@app_name}-#{@stage_name}" if @ssh_name.blank?

    print "Where does th'code come frem: [git@github.com:hanseventures/#{@app_name}.git] "
    @repo_url = STDIN.gets.strip
    @repo_url = "git@github.com:hanseventures/#{@app_name}.git" if @repo_url.blank?

    print "Which brrranch does '#{@stage_name}' d'ploy frem: [dev] "
    @branch_name = STDIN.gets.strip
    @branch_name = "dev" if @branch_name.blank?

    print "Whats the name of #{@stage_name}'s rails-environment: [prestage] "
    @rails_env = STDIN.gets.strip
    @rails_env = "prestage" if @rails_env.blank?

    print "Now give of '#{@stage_name}' a host-name: [dev.#{@app_name}.com] "
    @host_name = STDIN.gets.strip
    @host_name = "dev.#{@app_name}.com" if @host_name.blank?

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

def deploy_mate_face
<<-EOS

                       ZMMMMMMM.                            
               ..MMMMMMMMMMMM .                             
             MMMMIIIIMMMM$IIIMMMM.                          
           MMMI7$$$$MMMDNMM:MMDIMMM                         
        .MMMNZ$$$$$MMMMM=:~~~~~NNIIMN.                      
   .   MMN$$$$$$$$NMM:MMN.,MMM:=~M$INMD                     
MMMMMMMM$ZZZZ8MMMMM~M.,., .....M~~M$$IMM,                   
MMMMMMMMMMMN::~MN7~M...........,M~MNN$$ZM$.                 
MMMM~~~~~MON:,:O~~M.......,......M~M$ZM$IMM,                
 .M78MMMM7~:~~~~~=M.....MN7M....,M:MMDZ7NIMM                
 ,MM,. ...DMM::~~:M,...MIZM.IM...M~O7MMM$M$MM .             
.MM........Z~:~~~~M:...8DMM$OM...M~~IMZ$MZNMMMMM.MMMMMMN.   
MM........,M::~~~~M:::,M7O88M,..ND~~:IM$7MM~~~:MMMII$7INMN  
MM.....MM..M:~~~~~:M::::....:::,M:~~~7IN7M::M~~~MMMNMMM7$MM 
MM.....MMN.MM,:::~~~M:~,::::::MM~~N~~+~~7I~M==:~MZZZ$$$$MM. 
.M=.......MD:::::?=~MM8MMMMMMM~~MM~~:::~~:~,M~~:MZZZZZMMM.  
.MM=::::::M~~~~++~:~~~~~,MM==~MD=:~,,:::~~~~M~:MDZZMM?MMM   
  M+NMMMMMNMO~~~~~~:MM:~~M=MMM~~:~~~~~~:~+~~~M+MMZDMMMZIMM. 
 .M:~:NM:...M======+==M~::M:,,OM,~~~~~~~~=M=NMM=NMMZZZ$$MM  
.?MMIZNM...:MMI==DM+==~~~=M:..?M~~~.,::~~=MIM=M?=M..,MMMM,. 
IMM:.:MM+,,+MMMMMMMMM?+==M:,, DM~~:~+MM.~=M?7N+ZM
.MN:.:MMM+:,:::::::::,::~MMMMMMMMMMMM:~~~~:M?$?M.
 .MMM+,::~~~~~~~~~~~~~~~~~~:::::::~~~~~~M==N....
 MM::~~~~~~=======~~~~~~~~~~~~~~~~~~~~O=~N?M.
 M~~~~===MMMMM$?$DO===~~~~~~~~~~~~~~~~~~=+M.                
 MM~==+~:~MM~::::~:,,~~~~~~~~~~~~~~~~~~=MM$.                
 MM=+=~:::~:~:::::,,,,::::::::~~~~~~~=+=M.                  
 MM===~~~~~~~~:::::::~~~~~::::::O~M=M=IM                    
 MM==~~~~~~~::::~~~~~~~~~~~~~~:Z~$~8~MZ.                    
 MM=+===~~::::~~~~~~~~~~~~~==+===::ZM                       
 .M+~===+:~:::::::::::::~~++=?~~~M8.                        
  $M++$+::+:I:~~~~~~~~~:~~:~=:ZO,.                          
   .MM=~7:===:~::NNZZZMMZ+ZZM                               
     .MZZMMMMZ$..       .                                   
        ..            
EOS
end