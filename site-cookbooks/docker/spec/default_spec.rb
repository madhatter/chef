require 'chefspec'

describe 'docker::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'installs docker' do
    expect(chef_run).to install_package('docker')
  end

  it 'creates conf.d directory if necessary' do
    expect(chef_run).to create_directory('/etc/conf.d').with(
      user:  'root',
      group: 'root',
      mode:  '0755',
    )
  end

  it 'creates a docker template in /etc/conf.d' do
    expect(chef_run).to create_template('/etc/conf.d/docker').with(
      user:  'root',
      group: 'root',
      mode:  '0644',
    )
  end

  it 'creates some cron jobs' do
    expect(chef_run).to create_cron('Remove old docker containers').with(
      weekday: '1',
      user: 'root',
    )
    expect(chef_run).to create_cron('Remove dangling docker images').with(
      weekday: '*',
      user: 'root',
    )
    expect(chef_run).to create_cron('Remove untagged docker images').with(
      weekday: '*',
      user: 'root',
    )
  end
end
