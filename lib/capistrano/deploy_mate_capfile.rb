# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Includes tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#
# require 'capistrano/rbenv'
# require 'capistrano/chruby'

require 'capistrano/bundler'

# Load helper file
require "capistrano/helpers.rb"

# Load custom modules with helper functions
%w(aptitude bluepill upstart user_management shell).each do |m|
  load File.expand_path("../modules/#{m}.rb", __FILE__)
end

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
%w(bluepill logrotate machine elasticsearch nginx rvm unicorn puma upstart).each do |t|
  import File.expand_path("../tasks/#{t}.rake", __FILE__)
end
