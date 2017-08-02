# config valid only for current version of Capistrano
lock "3.9.0"

set :application, "quanswer"
set :repo_url, "git@github.com:davinciRor/quanswer.git"

set :deploy_to, "/home/deployer/quanswer"
set :deploy_user, 'deployer'
set :user, 'deployer'

append :linked_files, "config/database.yml", ".env"

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

namespace :deploy do
  desc 'Restart Application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join['tmp/restart.txt']
    end
  end

  after :publishing, :restart
end
