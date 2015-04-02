# deploy-module

Deploy submodule for capistrano

## Howto

__NOTE:__ execute all commands in project root

### Prepare app
Add Depending gems to Gemfile

  ```
    group :development do
      gem 'capistrano', '~> 3.0'
      gem 'capistrano-rvm', require: false
      gem 'capistrano-rails', require: false
      gem 'capistrano-bundler', require: false
    end
    gem 'therubyracer', platforms: :ruby
    gem 'unicorn'
    gem 'unicorn-rails'

  ```
Bundle and generate capistrano files

  ```
    bundle
    bundle exec cap install
  ```

Remove default capistrano dir (gets replaced by submodule)

  ```
    rm -r lib/capistrano
  ```

__NOTE:__ remove ```lib/capistrano``` folder from git index if capistrano exists before

Init submodule and pull code

  ```
    git submodule add git@github.com:hanseventures/deploy-module.git lib/capistrano/
    cd lib/capistrano && git pull
  ```

Copy example files

  ```
    cat lib/examples/Capfile > Capfile
    cat lib/examples/deploy.rb > config/deploy.rb
    cat lib/examples/stage.rb > config/deploy/production.rb
  ```

Add custom stages (e.g. 'prestage') and adjust the settings in ```config/deploy.rb```. Use the environment files in ```config/deploy/``` to fit your needs.

__NOTE:__ run ```cap -T``` to get a list of all possible capistrano commands

### Prepare server

Create folder structure (use prestage env for this example. Make sure ``` prestage.rb ``` exists in ```config/environments/``` __and__ ```config/deploy/```)

  ```
    bundle exec cap prestage deploy:check
  ```

Install config files

  ```
    bundle exec cap prestage install:configs
  ```

Deploy the app

  ```
    bundle exec cap prestage deploy
  ```

