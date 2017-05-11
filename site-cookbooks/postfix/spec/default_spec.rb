require_relative '../../spec_helper.rb'

describe 'postfix::default' do
  it 'installs postfix' do
    expect(chef_run).to install_package('postfix')
  end
end
