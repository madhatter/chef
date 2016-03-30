%w{ dnsmasq hostapd iptables}.each do |software|
  package software do
    action :install
  end
end

wifi_secret = data_bag_item('production', 'passwords', 'tor')

template '/etc/hostapd/hostapd.conf' do
  source 'hostapd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(:wifi_secret => wifi_secret)
  action :create
end 
