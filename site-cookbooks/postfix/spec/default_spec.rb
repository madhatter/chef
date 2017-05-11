require_relative '../../spec_helper.rb'

describe 'postfix::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'arch', version: '4.5.4-1-ARCH')
    .converge(described_recipe) }

  it 'installs postfix' do
    expect(chef_run).to install_package('postfix')
  end
end
