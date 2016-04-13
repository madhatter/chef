package 'irssi' do
  action :install
end

passwords = data_bag_item('production', 'irssi', IO.read('/etc/chef/encrypted_data_bag_secret'))

template "/home/#{node[:irssi][:user]}/.irssi/config" do
  source 'config.erb'
  owner "#{node[:irssi][:user]}"
  group "users"
  mode '0644'
  variables(:passwords => passwords)
  action :create
end

%w{ adv_windowlist.pl chanshare.pl dccstat.pl hilightwin.pl keepnick.pl
    notonline.pl autorealname.pl country.pl friends.pl irssinotifier.pl
    nickcolor.pl title.pl
  }.each do |file|
  cookbook_file "/home/#{node[:irssi][:user]}/.irssi/#{file}" do
    source "scripts/#{file}"
    owner "#{node[:irssi][:user]}"
    group "users"
    mode '0644'
    action :create
  end
end
