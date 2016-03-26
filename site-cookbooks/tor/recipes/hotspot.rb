%w{ dnsmasq hostapd iptables}.each do |software|
  package software do
    action :install
  end
end
