require_relative '../../spec_helper.rb'

describe 'tor::default' do
  let(:chef_run) do
    # Redirecting stdout to suppress iptables_ng_chain noise.
    old_std_out = $stdout.clone
    $stdout.reopen('tmp_std_out.txt', 'w')
    result = ChefSpec::SoloRunner.new do |node|
      node.set['tor']['data_bag_dir'] = File.expand_path('./encrypted_data_bag_secret', File.dirname(__FILE__))
    end.converge(described_recipe)
    $stdout.reopen(old_std_out)
    File.read('tmp_std_out.txt').each_line do |lin|
      puts lin unless lin =~ /iptables_ng_chain/
    end
    File.delete('tmp_std_out.txt')
    result
  end

  databag_stub = {
    'tor' => 'gammel'
  }

  before do
    secret_file = File.expand_path('./encrypted_data_bag_secret', File.dirname(__FILE__))
    secret = Chef::EncryptedDataBagItem.load_secret(secret_file)
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('production', 'passwords', secret).and_return(databag_stub)
  end

  %w(dnsmasq hostapd iptables tor).each do |package|
    it "installs #{package}" do
      expect(chef_run).to install_package(package)
    end
  end

  it 'creates hostapd config file with credentials' do
    expect(chef_run).to create_template('/etc/hostapd/hostapd.conf')
    expect(chef_run).to render_file('/etc/hostapd/hostapd.conf').with_content(/gammel/)
  end

  it 'creates openwifi unit file' do
    expect(chef_run).to create_cookbook_file('/etc/systemd/system/openwifi.service')
  end

  it 'creates tor config file' do
    expect(chef_run).to create_cookbook_file('/etc/tor/torrc')
  end

  it 'creates systemd service sub-directory' do
    expect(chef_run).to create_directory('/etc/systemd/system/tor.service.d')
  end

  it 'creates tor config file for systemd' do
    expect(chef_run).to create_cookbook_file('/etc/systemd/system/tor.service.d/start-as-root.conf')
  end

  it 'creates sysctl config' do
    expect(chef_run).to create_cookbook_file('/etc/sysctl.d/99-sysctl.conf')
  end

  it 'notifies sysctl' do
    resource = chef_run.cookbook_file('/etc/sysctl.d/99-sysctl.conf')
    expect(resource).to notify('execute[sysctl reload]').to(:run).immediately
  end
end
