package 'irssi' do
  action :install
end

secret = Chef::EncryptedDataBagItem.load_secret(node['irssi']['data_bag_dir'])
passwords = Chef::EncryptedDataBagItem.load('production', 'irssi', secret)

directory "/home/#{node['irssi']['user']}/.irssi/scripts" do
  owner "#{node['irssi']['user']}"
  group "users"
  mode '0755'
  recursive true
  action :create
end

template "/home/#{node['irssi']['user']}/.irssi/config" do
  source 'config.erb'
  owner node['irssi']['user']
  group "users"
  mode '0644'
  variables(:passwords => passwords)
  action :create
end

%w{ adv_windowlist.pl chanshare.pl dccstat.pl hilightwin.pl keepnick.pl
    notonline.pl autorealname.pl country.pl friends.pl irssinotifier.pl
    nickcolor.pl title.pl
  }.each do |file|
  cookbook_file "/home/#{node['irssi']['user']}/.irssi/scripts/#{file}" do
    source "scripts/#{file}"
    owner node['irssi']['user']
    group "users"
    mode '0644'
    action :create
  end
end
