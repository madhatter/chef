require_relative '../../spec_helper.rb'

describe 'base::git' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['user']['name'] = 'horst'
    end.converge(described_recipe)
  end

  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('base::user')
  end

  it 'installs git' do
    expect(chef_run).to install_package('git')
  end

  it 'creates git config files for a user' do
    expect(chef_run).to create_template('/home/horst/.gitconfig')
    expect(chef_run).to create_template('/home/horst/.gitignore')
  end

  it 'includes the base::user recipe' do
    expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('base::user')
    chef_run
  end
end
