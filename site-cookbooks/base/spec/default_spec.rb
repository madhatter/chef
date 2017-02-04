require_relative '../../spec_helper.rb'

describe 'base::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'arch', version: '4.5.4-1-ARCH').converge(described_recipe) }

  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('base::git')
  end

  it 'includes the base::git recipe' do
    expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('base::git')
    chef_run
  end
end
