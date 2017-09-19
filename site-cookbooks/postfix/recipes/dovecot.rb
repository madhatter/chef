package 'dovecot' do
  action :install
end

if ::Dir['/etc/dovecot/conf.d/*'].empty?
  ruby_block "Copy example config files if there are no configuration files yet" do
    block do
      ::FileUtils.cp '/usr/share/doc/dovecot/example-config/dovecot.conf', '/etc/dovecot'
      ::FileUtils.cp_r '/usr/share/doc/dovecot/example-config/conf.d', '/etc/dovecot'
    end
  end
end

template '/etc/dovecot/conf.d/10-ssl.conf' do
  source 'dovecot/ssl.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

cookbook_file '/etc/dovecot/conf.d/10-mail.conf' do
  source 'dovecot/10-mail.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

cookbook_file '/etc/dovecot/conf.d/15-lda.conf' do
  source 'dovecot/15-lda.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

cookbook_file '/etc/dovecot/conf.d/10-master.conf' do
  source 'dovecot/10-master.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

cookbook_file '/etc/dovecot/conf.d/10-master.conf' do
  source 'dovecot/10-master.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

#service 'dovecot' do
#  action [:enable, :start]
#end
