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

## Changelog
* **0.18.4 (2016-03-22)**: Added mandatory task to install `ssh_key`s
* **0.18.2 (2016-03-08)**: Added basic DDoS and flooding-proof via nginx `req_limit` and `fail2ban`
* **0.18.1 (2016-03-01)**: Added support for memcached
* **0.18 (2016-02-25)**: Added support for capistrano 3.4, Ask before overwriting existing config-files
* **2016-02-19**: Made selection of a deployed branch possible
* **2016-02-17**: Added support for puma as application server
* **2015-10-12**: Support additional linked-directories
* **2015-08-27**: Small fix for `nginx`-config regarding gzipping of svgs
* **2015-08-14**: Important small fix for `nginx`-config regarding ssl
* **2015-08-07**: Small fix for `rvm`-install
* **2015-08-06**: Support for optional `sidekiq`
* **2015-06-23**: Support for optional `elasticsearch`
* **2015-06-23**: Support for optional `whenever`
* **2015-06-23**: Support for optional `imagemagick`
* **2015-06-23**: Support creation of working `ubuntu` user. Error out if another user than `ubuntu` is used.
* **2015-06-22**: Support for choosing your Ruby-version when creating the `Capfile`. Suggestions come from `.ruby-version` and `Gemfile`.
* **2015-04-29**: Load custom rake tasks from lib/capistrano/tasks directory.
You need to run the generator ```rake deploy_mate:install``` again or add ```Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }``` to your Capfile.

## Installation
Add this to your project's `Gemfile`:

```
gem 'deploy_mate'
```
and run `bundle install`.

After installing the gem you need to generate the files needed to be able to deploy with **capistrano**.

Add this at **the end** of your project's `Rakefile`:
```
load 'deploy_mate/tasks.rake'
```
then run
```
rake deploy_mate:install
````

Follow the instructions.

This will create the following files for you:

```
Capfile
config/deploy.rb
config/deploy/<your-stage>.rb
```
When done: **Remove** `load 'deploy_mate/tasks.rake'` from your `Rakefile`. It is not needed anymore and will otherwise only cause problems.

## Updating the gem
Should you need to update your `deploy_mate`-version (e.g. because somebody fixed a bug in the gem), run:
```
bundle update deploy_mate
```
This will bump you up to the latest repo-version.

## Setting up a server
1. Spawn yourself a basic **Ubuntu 14** at the provider of your choice.
2. Create a working SSH-configuration for that server and try it our using `ssh <your-server-name>`
3. Run `cap <your-stage> machine:init` to install the needed packages.
4. Run `cap <your-stage> machine:setup` the setup all needed configuration-files on the server
5. Run `cap <your-stage> deploy branch=optional_branch` and be done.

## Reinstalling SSH-Keys
If you need to redeploy SSH Keys to your server (e.g. somebody leaves your team), run: 

```
bundle exec cap <your-stage> machine:install:ssh_keys
```

It will pull the SSH Keys from the location configured in your `deploy.rb`. You can also change it there.
