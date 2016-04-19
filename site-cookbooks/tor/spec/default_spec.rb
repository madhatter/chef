require_relative '../../spec_helper.rb'

describe 'tor::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['tor']['data_bag_dir'] = File.expand_path('./encrypted_data_bag_secret', File.dirname(__FILE__))
    end.converge(described_recipe)
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
end
