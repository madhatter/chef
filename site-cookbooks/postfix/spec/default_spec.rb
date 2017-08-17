require_relative '../../spec_helper.rb'

describe 'postfix::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'arch', version: '4.5.4-1-ARCH') do |node|
      node.normal['postfix']['server_name'] = 'mail.horst.org'
    end.converge(described_recipe)
  end

  it 'installs postfix' do
    expect(chef_run).to install_package('postfix')
  end

  it 'creates master.cf file' do
    expect(chef_run).to create_cookbook_file('/etc/postfix/master.cf')
  end

  it 'creates main.cf file' do
    expect(chef_run).to create_template('/etc/postfix/main.cf')
    expect(chef_run).to render_file('/etc/postfix/main.cf')
      .with_content(/mail\.horst\.org/)
  end
end
