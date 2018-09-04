package 'rsync' do
  action :install
end

user 'deployer' do
  gid 'wheel'
  home "/home/#{name}"
  shell '/bin/zsh'
  manage_home true
end

directory '/home/deployer' do
  owner 'deployer'
  group 'users'
  mode '0700'
  action :create
end


