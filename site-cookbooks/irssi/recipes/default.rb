package 'irssi' do
  action :install
end

cookbook_file "/home/#{node[:irssi][:user]}/.irssi/config" do
  source 'config'
  owner "#{node[:irssi][:user]}"
  group "#{node[:irssi][:user]}"
  mode '0644'
  action :create
end

%w{ adv_windowlist.pl chanshare.pl dccstat.pl hilightwin.pl keepnick.pl
    notonline.pl autorealname.pl country.pl friends.pl irssinotifier.pl
    nickcolor.pl title.pl
  }.each do |file|
  cookbook_file "/home/#{node[:irssi][:user]}/.irssi/#{file}" do
    source "plugins/#{file}"
    owner "#{node[:irssi][:user]}"
    group "#{node[:irssi][:user]}"
    mode '0644'
    action :create
  end
end
