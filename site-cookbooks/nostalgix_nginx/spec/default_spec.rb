require_relative '../../spec_helper.rb'

describe 'nostalgix_nginx::default' do
  before do
    stub_data_bag_item('nginx', 'nostalgix').and_return({ 'server_name' => 'gammel.org' })
  end

  let(:chef_run) do
     ChefSpec::SoloRunner.new do |node|
       node.set['nginx']['config_dir'] = '/etc/nginx'
    end.converge(described_recipe)
  end

  it 'installs nginx' do
    expect(chef_run).to install_package('nginx')
  end

  it 'creates nginx config from data_bag' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/nostalgix')
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix').with_content(/gammel\.org/)
  end
end
