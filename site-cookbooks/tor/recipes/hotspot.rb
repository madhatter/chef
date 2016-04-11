%w{ dnsmasq hostapd iptables}.each do |software|
  package software do
    action :install
  end
end

wifi_secret = data_bag_item('production', 'passwords', IO.read('/etc/chef/encrypted_data_bag_secret'))

log 'message' do
  message "Secret: #{wifi_secret['tor']}"
  level :info
end

template '/etc/hostapd/hostapd.conf' do
  source 'hostapd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(:wifi_secret => wifi_secret['tor'])
  action :create
end 

cookbook_file '/etc/systemd/system/openwifi.service' do
  source 'openwifi.service'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

cookbook_file '/etc/tor/torrc' do
  source 'torrc'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

directory '/etc/systemd/system/tor.service.d' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/systemd/system/tor.service.d/start-as-root.conf' do
  source 'tor_start-as-root.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

execute 'sysctl reload' do
  command 'sysctl --system'
  action :nothing
end

cookbook_file '/etc/sysctl.d/99-sysctl.conf' do
  source 'sysctl.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :run, 'execute[sysctl reload]', :immediately
end

iptables_ng_rule 'wlan_accept' do
  chain 'FORWARD'
  table 'filter'
  rule '-i wlan0 -j ACCEPT'
end

iptables_ng_rule 'port53' do
  chain 'PREROUTING'
  table 'nat'
  rule '-i wlan0 -p udp -m udp --dport 53 -j REDIRECT --to-ports 53'
end

iptables_ng_rule 'port9040' do
  chain 'PREROUTING'
  table 'nat'
  rule '-i wlan0 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j REDIRECT --to-ports 9040'
end

iptables_ng_rule 'masquerade' do
  chain 'POSTROUTING'
  table 'nat'
  rule '-o eth0 -j MASQUERADE'
end

service 'iptables' do
  action [:enable, :start]
end

service 'openwifi' do
  action [:enable, :start]
end

service 'hostapd' do
  action [:enable, :start]
end

service 'dnsmasq' do
  action [:enable, :start]
end

service 'tor' do
  action [:enable, :start]
end
