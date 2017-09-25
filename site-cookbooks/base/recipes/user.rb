#
# Cookbook Name: base
# Recipe: user
#
# Creates users with home
#
node['user']['users'].each do |name|
  user name do
    gid 'wheel'
    home "/home/#{name}"
    shell '/bin/zsh'
    manage_home true
  end

  directory "/home/#{name}" do
    owner name
    group 'users'
    mode '0700'
    action :create
  end
end
