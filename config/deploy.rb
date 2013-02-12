# Requirements
require "bundler/capistrano"
require './config/boot'
require 'airbrake/capistrano'

# Target Server
server "comments.eccu.org", :web, :app, :db, :primary => true

# Configuration
set :stages, %w{production}
set :application, "eccu-cms"
set :deploy_to, "/var/www/production.#{application}"
set :deploy_via, :remote_cache
set :repository,  "git@git.leesolutions.net:danlee/juvia.git"
set :use_sudo, false
set :user, "deploy"
set :scm, "git"
set :branch, "master"
set :default_environment, {
  'PATH' => "/home/deploy/.rvm/gems/ruby-1.9.3-p125@eccu-cms/bin:/home/deploy/.rvm/gems/ruby-1.9.3-p125@global/bin:/home/deploy/.rvm/rubies/ruby-1.9.3-p125/bin:/home/deploy/.rvm/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/deploy/bin:$PATH",
  'RUBY_VERSION' => 'ruby 1.9.3',
  'GEM_HOME' => '/home/deploy/.rvm/gems/ruby-1.9.3-p125@eccu-cms',
  'GEM_PATH' => '/home/deploy/.rvm/gems/ruby-1.9.3-p125@eccu-cms:/home/deploy/.rvm/gems/ruby-1.9.3-p125@global' 
}

# Options
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# Capistrano Additional Tasks and Overrides
namespace :deploy do

  desc "Symlink secret token for session"
  task :secret_token_symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end

  desc "Make sure config example files are avialable @ setup"
  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/config/initializers"
    put File.read("config/mongoid.example.yml"), "#{shared_path}/config/mongoid.yml"
    put File.read("config/initializers/secret_token.example.rb"), "#{shared_path}/config/initializers/secret_token.rb"
    puts "Now edit the config files in #{shared_path}."
  end
  
  desc "Symlink mongoid and secret token files"
  task :symlink_config, :roles => :app do
    run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
    run "ln -nfs #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
      puts "WARNING: HEAD is not the same as origin/#{branch}"
      puts "Run `git push` to sync changes."
      exit
    end
  end

end

# Hooks
after "deploy", "deploy:cleanup"
after "deploy", "deploy:secret_token_symlink"
after "deploy:setup", "deploy:setup_config"
after "deploy:finalize_update", "deploy:symlink_config"
before "deploy", "deploy:check_revision"

