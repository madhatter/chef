package 'dovecot' do
  action :install
end

if ::Dir['/etc/dovecot/conf.d/*'].empty?
  ruby_block "Copy example config files if there are no configuration files yet" do
    block do
      ::FileUtils.cp '/usr/share/doc/dovecot/example-config/dovecot.conf', '/etc/dovecot'
      ::FileUtils.cp '/usr/share/doc/dovecot/example-config/conf.d/*', '/etc/dovecot/conf.d'
    end
  end
end

#service 'dovecot' do
#  action [:enable, :start]
#end
