# The sturdy d'ploy-mate
<img src="http://hanseventures.s3.amazonaws.com/github/pirate-redbeard.png" width="300" />
> T'arrust me, bucko. I can do it.

This little gem can be added to your ruby-projects in order to **set up a working ruby-server** and **deploy** to it.

The resulting server will work with this setup: 
- NGINX Webserver (http://nginx.org/)
- Unicorn Rack App Server (http://unicorn.bogomips.org/)
- Bluepill Process Monitoring (https://github.com/bluepill-rb/bluepill)
- RVM as user-install (http://rvm.io)

Other stuff taken care of:
- Logration
- Automatic updates
- NTP

You can choose Database:
- MySQL
- Postgres

## Changelog
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
5. Run `cap <your-stage> deploy` and be done.
