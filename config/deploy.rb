require "bundler/capistrano"
require 'capistrano/ext/multistage'
require 'capistrano-unicorn'
 
set :stages, %w(demo)
set :default_stage, "demo"
 
# use RVM
set :rvm_ruby_string, '2.1.1@depot'
require "rvm/capistrano"
 
set :application, "depot"
set :repository,  "git@github.com:JurgisMegnis/depot.git"
set :scm, :git
 
default_run_options[:pty] = true
set :deploy_via, :remote_cache
set :use_sudo, false
set :branch, fetch(:branch, "master")
 
after "deploy:update_code", "deploy:symlink_sockets"
after "deploy:update_code", "deploy:symlink_revision"
after "deploy:update_code", "deploy:symlink_shared_uploads"
after "deploy:update_code", "deploy:symlink_config"
 
namespace :deploy do
  task :cold do       # Overriding the default deploy:cold
    setup
    setup_database_config
    update
    migrate
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
    start
  end
 
  task :symlink_sockets, :roles => :app do
    run "mkdir -p #{shared_path}/sockets"
    run "rm -rf #{latest_release}/tmp/sockets"
    run "ln -nfs #{shared_path}/sockets #{latest_release}/tmp/sockets"
  end
 
  task :symlink_revision, :roles => :app do
    run "ln -nfs #{latest_release}/REVISION #{latest_release}/public/REVISION"
  end
 
  task :symlink_shared_uploads, :roles => :app do
    run "mkdir -p #{shared_path}/uploads"
    run "mkdir -p #{shared_path}/private"
    run "rm -rf #{latest_release}/public/uploads"
    run "ln -nfs #{shared_path}/uploads #{latest_release}/public/uploads"
    run "ln -nfs #{shared_path}/system #{latest_release}/public/system"
    run "ln -nfs #{shared_path}/private #{latest_release}/private"
  end
 
 
  task :symlink_config, :roles => :app do
    run "ln -s #{shared_path}/database.yml #{latest_release}/config/database.yml"
    run "[ -f #{shared_path}/secrets.yml ] && ln -s #{shared_path}/secrets.yml #{latest_release}/config/secrets.yml; true"
  end
 
  desc "Create database yaml in shared path"
  task :setup_database_config do
    set :database_name do
      Capistrano::CLI.ui.ask("Database name: ")
    end
 
    set :database_username do
      Capistrano::CLI.ui.ask("Database username: ")
    end
 
    set :database_password do
      Capistrano::CLI.password_prompt "Database Password: "
    end
 
    db_config = <<-EOF
      demo:
        adapter: mysql2
        encoding: utf8
        reconnect: false
        pool: 5
        database: #{database_name}
        username: #{database_username}
        password: #{database_password}
    EOF
 
    put db_config, "#{shared_path}/database.yml"
  end
 
end
 
after "deploy:create_symlink", "deploy:migrate"
after "deploy", "deploy:cleanup"
after 'deploy:restart', 'unicorn:reload' # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'  # app preloaded