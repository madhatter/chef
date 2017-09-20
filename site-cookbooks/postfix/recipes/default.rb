package 'postfix' do
  action :install
end

cookbook_file '/etc/postfix/master.cf' do
  source 'master.cf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :restart, 'service[postfix]'
  notifies :restart, 'service[postgrey]' if node.recipe?['postfix:postgrey']
end

template '/etc/postfix/main.cf' do
  source 'main.cf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

template '/etc/postfix/aliases' do
  source 'aliases.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service 'postfix' do
  action [:enable, :start]
end
