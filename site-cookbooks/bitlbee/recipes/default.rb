unless node['data_bag_secret']
  Chef::Log.fatal('The node["data_bag_secret"] attribute is not set on this node,')
  Chef::Log.fatal('but it is necessary to generate valid configuration files.')
  Chef::Log.fatal('I am bailing here so this node does not upgrade.')
  raise
end

package 'bitlbee' do
  action :install
end

secret = Chef::EncryptedDataBagItem.load_secret(node['data_bag_secret'])
passwords = Chef::EncryptedDataBagItem.load('production', 'bitlbee', secret)

directory '/var/lib/bitlbee' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template '/var/lib/bitlbee/madhatter.xml' do
  source 'madhatter.xml.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables(:passwords => passwords)
  action :create
end
#
#%w{ adv_windowlist.pl chanshare.pl dccstat.pl hilightwin.pl keepnick.pl
#    notonline.pl autorealname.pl country.pl friends.pl irssinotifier.pl
#    nickcolor.pl title.pl
#  }.each do |file|
#  cookbook_file "/home/#{node['irssi']['user']}/.irssi/scripts/#{file}" do
#    source "scripts/#{file}"
#    owner node['irssi']['user']
#    group node['irssi']['user']
#    mode '0644'
#    action :create
#  end
#end
