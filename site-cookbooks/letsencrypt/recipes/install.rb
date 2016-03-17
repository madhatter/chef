# Recipe to install the letsencrypt tools from GitHub
directory "#{node[:letsencrypt][:dir]}" do
  action :create
  mode 0755
  owner 'root'
  group 'root'
end

git 'letsencrypt' do
  repository      "#{node[:letsencrypt][:dir]}"
  destination     '/usr/local/src/letsencrypt'
  checkout_branch 'master'
  action          :sync
end
