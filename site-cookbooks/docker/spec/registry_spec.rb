require_relative '../../spec_helper.rb'

describe 'docker::registry' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['docker']['registry_image'] = 'the_image'
    end.converge(described_recipe)
  end

  it 'creates directory for the registry' do
    expect(chef_run).to create_directory('/docker_repo').with(
      user:  'root',
      group: 'root',
      mode:  '0755',
    )
  end

  it 'creates a unit file for the registry' do
    expect(chef_run).to create_template('/etc/systemd/system/docker-registry.service').with(
      user:  'root',
      group: 'root',
      mode:  '0644',
    )
    expect(chef_run).to render_file('/etc/systemd/system/docker-registry.service').with_content(/the_image/)
  end
end
