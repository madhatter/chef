require_relative '../../spec_helper.rb'

describe 'base::user' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'arch', version: '4.5.4-1-ARCH') do |node|
      node.normal['user']['users'] = ['horst','klaus']
    end.converge(described_recipe)
  end

  it 'create user' do
    expect(chef_run).to create_user('horst').with(
      home: '/home/horst',
    )
    expect(chef_run).to create_user('klaus').with(
      home: '/home/klaus',
    )
  end

  it 'creates user\'s home' do
    expect(chef_run).to create_directory('/home/horst').with(
      user:   'horst',
      group:  'users',
      mode:   '0700',
    )
    expect(chef_run).to create_directory('/home/klaus').with(
      user:   'klaus',
      group:  'users',
      mode:   '0700',
    )
  end
end
