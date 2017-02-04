require_relative '../../spec_helper.rb'

describe 'letsencrypt::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'arch', version: '4.5.4-1-ARCH') do |node|
      node.normal['letsencrypt']['dir'] = '/usr/local/src/something'
      node.normal['letsencrypt']['repository'] = 'https://github.com/somerepo'
    end.converge(described_recipe)
  end

  it 'creates directory for git clone' do
    expect(chef_run).to create_directory('/usr/local/src/something').with(
      user:  'root',
      group: 'root',
      mode:  '0755',
    )
  end

  it 'creates renewal script from template' do
    expect(chef_run).to create_template('/usr/local/bin/renew_ssl_cert.sh').with(
      user:  'root',
      group: 'root',
      mode:  '0755',
    )
  end

  it 'checks out the letsencrypt repository' do
    expect(chef_run).to sync_git('letsencrypt').with(repository: 'https://github.com/somerepo')
  end

  it 'creates a cron job for certificate renewal' do
    expect(chef_run).to create_cron('Renew letsencrypt certificate').with(
      minute: '0',
      hour: '1',
      user: 'root',
    )
  end
end
