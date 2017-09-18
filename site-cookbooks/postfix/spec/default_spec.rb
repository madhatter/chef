require_relative '../../spec_helper.rb'

describe 'postfix::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'arch', version: '4.5.4-1-ARCH') do |node|
      node.normal['postfix']['server_name'] = 'mail.horst.org'
      node.normal['postfix']['user'] = 'herbert'
    end.converge(described_recipe)
  end

  it 'installs postfix' do
    expect(chef_run).to install_package('postfix')
  end

  it 'installs cyrus-sasl' do
    expect(chef_run).to install_package('cyrus-sasl')
  end

  it 'creates master.cf file' do
    expect(chef_run).to create_cookbook_file('/etc/postfix/master.cf')
  end

  it 'creates main.cf file' do
    expect(chef_run).to create_template('/etc/postfix/main.cf')
    expect(chef_run).to render_file('/etc/postfix/main.cf')
      .with_content(/mail\.horst\.org/)
  end

  it 'creates updated alias file' do
    expect(chef_run).to create_template('/etc/postfix/aliases')
    expect(chef_run).to render_file('/etc/postfix/aliases')
      .with_content(/herbert/)
  end

  it 'creates the sasl2 directory' do
    expect(chef_run).to create_directory('/etc/sasl2')
  end

  context 'sasl sasldb' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'arch', version: '4.5.4-1-ARCH') do |node|
        node.normal['postfix']['sasl_provider'] = 'sasldb'
      end.converge(described_recipe)
    end

    it 'creates smptd.conf file' do
      expect(chef_run).to create_template('/etc/sasl2/smtpd.conf')
    end

    it 'configures sasl with sasldb' do
      expect(chef_run).to render_file('/etc/sasl2/smtpd.conf')
        .with_content(/auxprop/)
    end

    it 'creates the sasldb2' do
      expect(chef_run).to create_cookbook_file('/etc/sasldb2').with(
        owner: 'postfix',
        group: 'root',
        mode: '0600',
      )
    end
  end

  context 'sasl pam' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'arch', version: '4.5.4-1-ARCH') do |node|
        node.normal['postfix']['sasl_provider'] = 'pam'
      end.converge(described_recipe)
    end
  
    it 'creates smptd.conf file' do
      expect(chef_run).to create_template('/etc/sasl2/smtpd.conf')
    end

    it 'configures sasl with pam' do
      expect(chef_run).to render_file('/etc/sasl2/smtpd.conf')
        .with_content(/saslauthd/)
    end

    it 'does not create the sasldb2' do
      expect(chef_run).to delete_cookbook_file('/etc/sasldb2').with(
        owner: 'postfix',
        group: 'root',
        mode: '0600',
      )
    end
  end
end
