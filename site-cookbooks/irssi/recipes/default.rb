unless node['data_bag_secret']
  Chef::Log.fatal('The node["data_bag_secret"] attribute is not set on this node,')
  Chef::Log.fatal('but it is necessary to generate valid configuration files.')
  Chef::Log.fatal('I am bailing here so this node does not upgrade.')
  raise
end

package 'irssi' do
  action :install
end

secret = Chef::EncryptedDataBagItem.load_secret(node['data_bag_secret'])
passwords = Chef::EncryptedDataBagItem.load('production', 'irssi', secret)

# workaround to have the right owner/group for all leafs of recursive paths
%W{ /home/#{node['irssi']['user']}/.irssi /home/#{node['irssi']['user']}/.irssi/scripts }.each do |path|
  directory path do
    owner "#{node['irssi']['user']}"
    group node['irssi']['user']
    mode '0755'
    action :create
  end
end

template "/home/#{node['irssi']['user']}/.irssi/config" do
  source 'config.erb'
  owner node['irssi']['user']
  group node['irssi']['user']
  mode '0644'
  variables(:passwords => passwords)
  action :create
end

%w{ adv_windowlist.pl chanshare.pl dccstat.pl hilightwin.pl keepnick.pl
    notonline.pl autorealname.pl country.pl irssinotifier.pl
    nickcolor.pl title.pl
  }.each do |file|
  cookbook_file "/home/#{node['irssi']['user']}/.irssi/scripts/#{file}" do
    source "scripts/#{file}"
    owner node['irssi']['user']
    group node['irssi']['user']
    mode '0644'
    action :create
  end
end

%w{ arvid.theme  default.theme default2.theme  madhatter.theme}.each do |theme|
  cookbook_file "/home/#{node['irssi']['user']}/.irssi/#{theme}" do
    source "themes/#{theme}"
    owner node['irssi']['user']
    group node['irssi']['user']
    mode '0644'
    action :create
  end
end

cookbook_file "/home/#{node['irssi']['user']}/.irssi/startup" do
  source "startup"
  owner node['irssi']['user']
  group node['irssi']['user']
  mode '0644'
  action :create
end
