require 'chefspec'

describe 'base::user' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['user']['name'] = 'horst'
    end.converge(described_recipe)
  end

  it 'create user' do
    expect(chef_run).to create_user('horst').with(
      home: '/home/horst',
    )
  end

  it 'creates user\'s home' do
    expect(chef_run).to create_directory('/home/horst').with(
      user:   'horst',
      group:  'users',
      mode:   '0700',
    )
  end
end
