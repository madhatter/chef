#
# Cookbook Name: docker
# Recipe: registry
#
# Installs base docker setup
#

include_recipe 'docker'

directory '/docker_repo' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template '/etc/systemd/system/docker-registry.service' do
  source 'registry/docker_registry_unit.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

