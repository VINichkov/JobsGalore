# config valid for current version and patch releases of Capistrano
#require 'net/ssh/proxy/command'

#lock "~> 3.11.0"
server 'ec2-18-188-218-128.us-east-2.compute.amazonaws.com',
       user: 'ubuntu',
       port: '22',
       roles: [:web, :app],
       primary: true,
       ssh_options: {
           user: 'ubuntu', # overrides user setting above
           keys: %w(Vyacheslav2406.pem),
           forward_agent: false,
           auth_methods: %w(publickey),
       }
#set :ssh_options, proxy: Net::SSH::Proxy::Command.new('ssh -i "Vyacheslav2406.pem" ec2-18-188-218-128.us-east-2.compute.amazonaws.com')
set :rvm_custom_path, '/usr/share/rvm'
set :application, "JobsGalore"
set :repo_url, "git@github.com:VINichkov/JobsGalore.git"
#set :puma_threads,    [4, 16]
#set :puma_workers,    0

set :pty,             true
set :use_sudo,        true
set :user,             'ubuntu'
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
#set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

set :DATABASE_URL, Figaro.env.DATABASE_URL
set :HOST, Figaro.env.HOST
set :LANG, Figaro.env.LANG
set :RACK_ENV, Figaro.env.RACK_ENV
set :RAILS_ENV, Figaro.env.RAILS_ENV
set :RAILS_LOG_TO_STDOUT, Figaro.env.RAILS_LOG_TO_STDOUT
set :RAILS_MAX_THREADS, Figaro.env.RAILS_MAX_THREADS
set :RAILS_SERVE_STATIC_FILES, Figaro.env.RAILS_SERVE_STATIC_FILES
set :REDIS_URL, Figaro.env.REDIS_URL
set :SECRET_KEY_BASE, Figaro.env.SECRET_KEY_BASE
set :EMAIL_LOGIN, Figaro.env.EMAIL_LOGIN
set :EMAIL_PASSWORD, Figaro.env.EMAIL_PASSWORD
set :S3_ACCESS_KEY_ID, Figaro.env.S3_ACCESS_KEY_ID
set :S3_SECRET_ACCESS_KEY, Figaro.env.S3_SECRET_ACCESS_KEY
set :MONGO_DATABASE_PASSWORD, Figaro.env.MONGO_DATABASE_PASSWORD
set :MONGO_DATABASE_USER, Figaro.env.MONGO_DATABASE_USER
set :DM_KIT_KEY, Figaro.env.DM_KIT_KEY
set :bucket, Figaro.env.bucket
set :region, Figaro.env.region
set :existing_remote_files, Figaro.env.existing_remote_files

## Defaults:
 set :branch,        :master
 set :format,        :pretty
 set :log_level,     :info
 set :keep_releases, 5

## Linked Files & Directories (Default None):
 set :linked_files, %w{key/private.pem}
 #set :linked_dirs,   %w{bin log tmp/pids tmp/cache tmp/sockets public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        #exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end


  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is Figaro.env.USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
