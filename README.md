# The sturdy d'ploy-mate
<img src="http://hanseventures.s3.amazonaws.com/github/deploy-mate.jpg" width="300" />
> T'arrust me, bucko. I can do it.

This little gem can be added to your ruby-projects in order to **set up a working ruby-server** and **deploy** to it **Hanse Ventures'** style.

## Installation
Add this to your project's `Gemfile`:

```
gem 'deploy_mate', git: 'https://58341dac36402a0305899f85ff7c32265ee89109@github.com/hanseventures/deploy-mate'
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

## Setting up a server
1. Spawn yourself a basic **Ubuntu 14** at the provider of your choice. 
2. Create a working SSH-configuration for that server and try it our using `ssh <your-server-name>`
3. Run `cap <your-stage> machine:init` to install the needed packages. 
4. Run `cap <your-stage> machine:setup` the setup all needed configuration-files on the server
5. Run `cap <your-stage> deploy` and be done.
