# The sturdy d'ploy-mate
<img src="http://hanseventures.s3.amazonaws.com/github/pirate-redbeard_1024.png" width="300" />
> T'arrust me, bucko. I can do it.

This little gem can be added to your ruby-projects in order to **set up a working ruby-server** and **deploy** to it.

The resulting server will work with this setup:
- NGINX Webserver (http://nginx.org/)
- Unicorn Rack App Server (http://unicorn.bogomips.org/) / Puma Rack App Server (http://puma.io/)
- Bluepill Process Monitoring (https://github.com/bluepill-rb/bluepill)
- RVM as user-install (http://rvm.io)
- [Optional] ImageMagick (http://www.imagemagick.org)

Other stuff taken care of:
- Logration
- Automatic updates
- NTP

You can choose a Database-Engine:
- MySQL
- Postgres

**If you are not using Amazon AWS as a host:** The GEM needs a working Amazon AWS-style `ubuntu`-user on the system in order to work properly. It will create one, if needed.

It uses the following Capistrano-roles to divide the installed components:
- **web**: Machines with this role run NGINX as proxy
- **app**: Machines with this role run the Ruby-webapp
- **search**: [OPTIONAL] Machines with this role run ElasticSearch
- **cronjobs**: [OPTIONAL] For environments where `whenever` should manage/run cronjobs

## Installation
* Add the gem to your Gemfile (`gem 'deploy_mate'`) and run `bundle install`.
* Spawn yourself a basic **Ubuntu 14** at the provider of your choice.
* Create a working SSH-configuration for that server and try it out using `ssh <your-server-name>`.

## Generate the Capistrano files
* Generate the configuration file: `bundle exec rake deploy_mate:default_config`
* Edit the configuration file: `open config/deploy_mate.yml`
* Generate the Capistrano files out of the config: `bundle exec rake deploy_mate:install`

**NOTE** for non-rails applications:
Since rails supports auto-loading rake tasks, any non-rails application must load the deploy mate rake tasks manually.
At **the end** of the your project's `Rakefile`:
```
load 'deploy_mate/tasks.rake'
```
When done: **Remove** `load 'deploy_mate/tasks.rake'` from your `Rakefile`. It is not needed anymore and will otherwise only cause problems.

## Using deploy mate

### Initialize needed server packages
```
bundle exec cap <your-stage> machine:init
```

### Copy needed templates
```
bundle exec cap <your-stage> machine:setup
```

### Deploy the application
```
bundle exec cap <your-stage> deploy
```

### Reinstalling SSH-Keys
If you need to redeploy SSH Keys to your server (e.g. somebody leaves your team),you can
always come back to your configuration file at `config/deploy_mate.yml`, change the
values and generate the Capistrano files again with `bundle exec rake deploy_mate:install`.
To setup just the ssh keys run:

```
bundle exec cap <your-stage> machine:install:ssh_keys
```
