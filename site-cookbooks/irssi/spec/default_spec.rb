require 'chefspec'

describe 'irssi::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['irssi']['user'] = 'horst'
      node.set['irssi']['data_bag_dir'] = File.expand_path('./encrypted_data_bag_secret', File.dirname(__FILE__))
    end.converge(described_recipe)
  end

  databag_stub = {
    'freenode' => 'gammel',
    'oftc' => 'bammel'
  }

  before do
    #stub_data_bag_item('production', 'irssi', 'secret').and_return(databag_stub)
    secret_file = File.expand_path('./encrypted_data_bag_secret', File.dirname(__FILE__))
    secret = Chef::EncryptedDataBagItem.load_secret(secret_file)
    #Chef::EncryptedDataBagItem.stub(:load).with('production', 'irssi', secret).and_return(databag_stub)
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('production', 'irssi', secret).and_return(databag_stub)
  end

  it 'installs irssi' do
    expect(chef_run).to install_package('irssi')
  end

  it 'creates irssi config files with credentials' do
    expect(chef_run).to create_template('/home/horst/.irssi/config')
    expect(chef_run).to render_file('/home/horst/.irssi/config').with_content(/gammel/)
    expect(chef_run).to render_file('/home/horst/.irssi/config').with_content(/bammel/)
  end
end