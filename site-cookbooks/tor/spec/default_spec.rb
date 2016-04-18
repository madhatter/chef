require_relative '../../spec_helper.rb'

describe 'tor::default' do
  let(:chef_run) do
    cookbook_paths = %W(#{File.expand_path('../../..', Dir.pwd)}/site-cookbooks #{File.expand_path('../../..', Dir.pwd)}/cookbooks)
    ChefSpec::SoloRunner.new({cookbook_path: cookbook_paths}) do |node|
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
    allow(Kernel).to receive(:require).with('iptables-ng').and_return(true)
  end

  it 'installs dnsmasq' do
    expect(chef_run).to install_package('dnsmasq')
  end
end
