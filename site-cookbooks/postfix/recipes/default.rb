package 'postfix' do
  action :install
end

cookbook_file '/etc/postfix/master.cf' do
  source 'master.cf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
