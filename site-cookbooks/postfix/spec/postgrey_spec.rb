require_relative '../../spec_helper.rb'

describe 'postfix::postgrey' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'arch', version: '4.5.4-1-ARCH') do |node|
      node.normal['postfix']['server_name'] = 'mail.horst.org'
      node.normal['postfix']['user'] = 'herbert'
      #node.run_list(['postfix:postgrey'])
    end.converge(described_recipe)
  end

  it 'installs postgrey' do
    expect(chef_run).to install_package('postgrey')
  end

  it 'changes the postfix configuration' do
    expect(chef_run).to render_file('/etc/postfix/main.cf')
      .with_content(/check_policy_service\sinet:\S*:10030/)
  end

  it 'enables the service' do
    expect(chef_run).to enable_service('postgrey')
  end
end


