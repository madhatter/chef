require_relative '../../spec_helper.rb'

describe 'nostalgix_nginx::default' do
  before do
    stub_data_bag_item('nginx', 'nostalgix.org').and_return({
      'server_name' => 'gammel.org',
      'http_port' => '80',
      'https_port' => '443',
      'ssl_certificate' => '/some_dir/gammelcert',
      'ssl_certificate_key' => '/some_dir/gammelkey',
      'access_log' => '/logdir/logfile',
      'root_dir' => '/wwwhome',
      'location' => { '/' => 'index  index.html index.htm index.php' }
    })
    stub_data_bag_item('nginx', 'share.nostalgix.org').and_return({
      'server_name' => 'share.gammel.org',
      'http_port' => '80',
      'access_log' => '/logdir/share_logfile',
      'root_dir' => '/wwwhome_share',
      'location' => { '/' => 'autoindex on' }
    })
  end

  let(:chef_run) do
     ChefSpec::SoloRunner.new do |node|
       node.set['nginx']['config_dir'] = '/etc/nginx'
       node.set['nginx']['sites'] = ['nostalgix.org','share.nostalgix.org']
    end.converge(described_recipe)
  end

  it 'installs nginx' do
    expect(chef_run).to install_package('nginx')
  end

  it 'creates nginx config from data_bag' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/nostalgix.org')
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix.org')
      .with_content(/www\.gammel\.org/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix.org')
      .with_content(/gammel\.org/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix.org')
      .with_content(/80/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix.org')
      .with_content(/443/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix.org')
      .with_content(/\/some_dir\/gammelcert/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix.org')
      .with_content(/\/some_dir\/gammelkey/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix.org')
      .with_content(/\/logdir\/logfile/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix.org')
      .with_content(/\/wwwhome/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/nostalgix.org')
    .with_content(/index\s\sindex.html\sindex.htm\sindex.php/)
  end

  it 'creates nginx config from data_bag with less options' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/share.nostalgix.org')
    expect(chef_run).to render_file('/etc/nginx/sites-available/share.nostalgix.org')
      .with_content(/share\.gammel\.org/)
    expect(chef_run).not_to render_file('/etc/nginx/sites-available/share.nostalgix.org')
      .with_content(/www\.share\.gammel\.org/)
    expect(chef_run).not_to render_file('/etc/nginx/sites-available/share.nostalgix.org')
      .with_content(/443/)
    expect(chef_run).not_to render_file('/etc/nginx/sites-available/share.nostalgix.org')
      .with_content(/ssl_certificate/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/share.nostalgix.org')
      .with_content(/\/logdir\/share_logfile/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/share.nostalgix.org')
      .with_content(/\/wwwhome_share/)
    expect(chef_run).to render_file('/etc/nginx/sites-available/share.nostalgix.org')
      .with_content(/autoindex\son/)
  end

  it 'disables the default site configuration' do
    expect(chef_run).to delete_link('/etc/nginx/sites-enabled/default')
  end

  it 'creates links to enable sites' do
    expect(chef_run).to create_link('/etc/nginx/sites-enabled/nostalgix.org')
      .with(link_type: :symbolic)
    expect(chef_run).to create_link('/etc/nginx/sites-enabled/share.nostalgix.org')
      .with(link_type: :symbolic)
  end
end
