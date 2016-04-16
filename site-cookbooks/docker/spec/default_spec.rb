require_relative '../../spec_helper.rb'

describe 'docker::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['docker']['insecure_registries'] = ['first_insec_registry', 'second_insec_registry']
    end.converge(described_recipe)
  end

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
    expect(chef_run).to render_file('/etc/conf.d/docker').with_content(
      'DOCKER_OPTS="--insecure-registry first_insec_registry:5000 '\
      '--insecure-registry second_insec_registry:5000 "'
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
