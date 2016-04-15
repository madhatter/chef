# Recipe to install the letsencrypt tools from GitHub
#
# Initially create certificate with letsencrypt-auto certonly -d <domain> --debug

directory node['letsencrypt']['dir'] do
  action :create
  mode '0755'
  owner 'root'
  group 'root'
end

git 'letsencrypt' do
  repository 'https://github.com/letsencrypt/letsencrypt.git'
  destination node['letsencrypt']['dir']
  reference 'master'
  action :sync
  user 'root'
end

template '/usr/local/bin/renew_ssl_cert.sh' do
  source 'renew_ssl_cert.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cron 'Renew letsencrypt certificate' do
  command '/usr/local/bin/renew_ssl_cert.sh >/var/log/letsencrypt_renew_cron.log 2>&1'
  minute '0'
  hour '1'
  user 'root'
  action :create
end
