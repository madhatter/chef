package 'postfix' do
  action :install
end

package 'cyrus-sasl' do
  action :install
end

cookbook_file '/etc/postfix/master.cf' do
  source 'master.cf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

template '/etc/postfix/main.cf' do
  source 'main.cf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

template '/etc/postfix/aliases' do
  source 'aliases.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

directory '/etc/sasl2' do
  action :create
  owner 'root'
  group 'root'
  mode '0755'
end

template '/etc/sasl2/smtpd.conf' do
  source 'smtpd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

cookbook_file '/etc/sasldb2' do
  source 'sasldb2'
  owner 'postfix'
  group 'root'
  mode '0600'
  if node['postfix']['sasl_provider'] == 'sasldb'
    action :create
  else
    action :delete
  end
end

service 'postfix' do
  action [:enable, :start]
end
