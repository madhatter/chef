require 'chefspec'

describe 'base::git' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['user']['name'] = 'horst'
    end.converge(described_recipe)
  end

  it 'installs git' do
    expect(chef_run).to install_package('git')
  end

  it 'creates git config files for a user' do
    expect(chef_run).to create_template('/home/horst/.gitconfig')
    expect(chef_run).to create_template('/home/horst/.gitignore')
  end
end
