server "192.165.67.169", :web, :app, :db, :primary => true
ssh_options[:forward_agent] = true
ssh_options[:port] = 3333
set :user, "demo"
set :deploy_to, "/home/demo/apps/#{application}"
set :rails_env, "demo"
load 'deploy/assets'