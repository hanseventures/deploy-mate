# Place all custom helper methods used in capistrano tasks here
# This file is loaded before the tasks

def template(from, to)
  path = File.expand_path("lib/capistrano/configs/#{from}", ENV['PWD'])
  path = File.expand_path("../configs/#{from}", __FILE__) unless File.exist?(path)
  erb = File.read(path)
  compiled = ERB.new(erb).result(binding)
  io = StringIO.new(compiled)
  upload! io, to
end

def set_default(name, *args, &block)
  set(name, *args, &block) if fetch(name).nil?
end

def execute_script(name, params = "")
  upload! File.expand_path("../scripts/#{name}", __FILE__), name.to_s
  execute "chmod 755 #{name}"
  execute "./#{name} #{params}"
  execute "rm #{name}"
end
