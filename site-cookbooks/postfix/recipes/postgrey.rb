include_recipe 'postfix::default'

package 'postgrey' do
  action :install
end

service 'postgrey' do
  action [:enable, :start]
end
