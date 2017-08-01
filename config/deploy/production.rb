role :app, %w{deployer@82.202.212.203}
role :web, %w{deployer@82.202.212.203}
role :db,  %w{deployer@82.202.212.203}

set :rails_env, :production

server '82.202.212.203', user: 'deployer', roles: %w(web app db), primary: true

set :ssh_options, {
  keys: %w(/Users/davinci/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 4321
}