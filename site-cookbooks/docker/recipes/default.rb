#
# Cookbook Name: docker
# Recipe: default
#
# Installs base docker setup
#

package 'docker' do
  action :install
end

directory '/etc/conf.d' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template '/etc/conf.d/docker' do
  source 'docker_conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
