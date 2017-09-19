require_relative '../../spec_helper.rb'

describe 'postfix::dovecot' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'arch', version: '4.5.4-1-ARCH') do |node|
      node.normal['postfix']['server_name'] = 'mail.horst.org'
      node.normal['postfix']['user'] = 'herbert'
    end.converge(described_recipe)
  end

  it 'installs dovecot' do
    expect(chef_run).to install_package('dovecot')
  end

  it 'creates the config files' do
    expect(chef_run).to create_template('/etc/dovecot/conf.d/10-ssl.conf')
    expect(chef_run).to create_cookbook_file('/etc/dovecot/conf.d/10-mail.conf')
    expect(chef_run).to create_cookbook_file('/etc/dovecot/conf.d/15-lda.conf')
    expect(chef_run).to create_cookbook_file('/etc/dovecot/conf.d/10-master.conf')
    expect(chef_run).to create_cookbook_file('/etc/pam.d/dovecot')
  end

  it 'enables the service' do
    expect(chef_run).to enable_service('dovecot')
  end
end

