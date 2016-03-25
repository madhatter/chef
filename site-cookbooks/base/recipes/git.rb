#
# Cookbook Name: base
# Recipe: git
#
# Installs and sets up git
#

include_recipe 'base::user'

package 'git' do
  action :install
end

# $HOME/.gitconfig und $HOME/.gitignore
template "/home/#{node[:user][:name]}/.gitconfig" do
  source 'gitconfig.erb'
  owner "#{node[:user][:name]}"
  group "#{node[:user][:name]}"
  mode '0644'
  action :create
end

template "/home/#{node[:user][:name]}/.gitignore" do
  source 'gitignore.erb'
  owner "#{node[:user][:name]}"
  group "#{node[:user][:name]}"
  mode '0644'
  action :create
end

