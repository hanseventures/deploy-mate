* **0.25 (2016-05-23)**: Support multiple stages in YAML-file.
* **0.2 (2016-05-18)**: Configuration moved to YAML-file. SSH-Keys optional. Config-templates overwritable locally.
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
