#
# Cookbook Name: docker
# Recipe: default
#
# Installs base docker setup
#

package 'docker' do
  action :install
end

template '/etc/conf.d/docker2' do
  source 'docker_conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
