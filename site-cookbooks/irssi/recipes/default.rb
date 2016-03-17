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


