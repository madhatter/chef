require_relative '../../spec_helper.rb'

describe 'bitlbee::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'arch', version: '4.5.4-1-ARCH') do |node|
      node.normal['data_bag_secret'] = File.expand_path('./encrypted_data_bag_secret', File.dirname(__FILE__))
    end.converge(described_recipe)
  end

  databag_stub = {
    'bitlbee' => 'blubber',
    'icq' => 'gammel',
    'jabber' => 'bammel'
  }

  before do
    secret_file = File.expand_path('./encrypted_data_bag_secret', File.dirname(__FILE__))
    secret = Chef::EncryptedDataBagItem.load_secret(secret_file)
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('production', 'bitlbee', secret).and_return(databag_stub)
    allow_any_instance_of(Chef::Recipe).to receive(:search).with(:node, "my_recipe:*").and_return([{"hostname" => "node1.example.com" }, {"hostname" => "node2.example.com"}])
  end

  it 'installs bitlbee' do
    expect(chef_run).to install_package('bitlbee')
  end

  it 'creates bitlbee directory' do
    expect(chef_run).to create_directory('/var/lib/bitlbee')
  end

  it 'creates bitlbee config file with credentials' do
    expect(chef_run).to create_template('/var/lib/bitlbee/madhatter.xml')
    expect(chef_run).to render_file('/var/lib/bitlbee/madhatter.xml').with_content(/blubber/)
    expect(chef_run).to render_file('/var/lib/bitlbee/madhatter.xml').with_content(/gammel/)
    expect(chef_run).to render_file('/var/lib/bitlbee/madhatter.xml').with_content(/bammel/)
  end
end
