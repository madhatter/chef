require 'chefspec'

describe 'letsencrypt::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['letsencrypt']['dir'] = '/usr/local/src/something'
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
end
