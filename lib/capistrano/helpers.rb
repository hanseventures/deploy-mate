# Place all custom helper methods used in capistrano tasks here
# This file is loaded before the tasks

def template(from, to)
  erb = File.read(File.expand_path("../configs/#{from}", __FILE__))
  compiled = ERB.new(erb).result(binding)
  io = StringIO.new(compiled)
  upload! io, to
end

def set_default(name, *args, &block)
  set(name, *args, &block) if fetch(name).nil?
end

def execute_script(name, params = "")
  upload! File.expand_path("../scripts/#{name}", __FILE__), "#{name}"
  execute "chmod 755 #{name}"
  execute "./#{name} #{params}"
  execute "rm #{name}"
end