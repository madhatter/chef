require_relative '../../spec_helper.rb'

describe 'nostalgix_nginx::default' do
  before do
    stub_data_bag_item('nginx', 'nostalgix').and_return({
      'server_name' => 'gammel.org',
      'http_port' => '80',
      'https_port' => '443',
      'ssl_certificate' => '/some_dir/gammelcert',
      'ssl_certificate_key' => '/some_dir/gammelkey',
      'access_log' => '/logdir/logfile',
      'root_dir' => '/wwwhome'
    })
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
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix').with_content(/80/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix').with_content(/443/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix').with_content(/\/some_dir\/gammelcert/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix').with_content(/\/some_dir\/gammelkey/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix').with_content(/\/logdir\/logfile/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix').with_content(/\/wwwhome/)
  end
end