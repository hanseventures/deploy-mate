Gem::Specification.new do |s|
  s.name                      = "deploy_mate"
  s.version                   = "0.26"

  s.authors                   = ["Tim Adler", "Marcus Geißler", "Johannes Strampe"]
  s.date                      = '2016-05-25'
  s.description               = 'This is how we deploy around here.'
  s.summary                   = s.description
  s.email                     = 'development (at) hanseventures (dot) com'
  s.license                   = "MIT"

  s.files                     = `git ls-files`.split("\n")
  s.test_files                = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.homepage                  = 'https://github.com/hanseventures/deploy-mate'
  s.require_paths             = ["lib"]
  s.rubygems_version          = '1.6.2'

  s.add_dependency 'capistrano', '~> 3.0'
  s.add_dependency 'capistrano-bundler'
  s.add_dependency 'capistrano-rails'
  s.add_dependency 'rake'

  s.add_development_dependency 'rubocop'
end
