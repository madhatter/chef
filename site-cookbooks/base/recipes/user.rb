#
# Cookbook Name: base
# Recipe: user
#
# Creates user with home
#

user "#{node[:user][:name]}" do
  gid 'wheel'
  home "/home/#{node[:user][:name]}"
  shell '/bin/zsh'
  supports :manage_home => true
end

directory "/home/#{node[:user][:name]}" do
  owner "#{node[:user][:name]}"
  group 'users'
  mode '0700'
  action :create
end

