data_bag = data_bag_item('nginx', 'nostalgix')

package 'nginx' do
  action :install
end

template '/etc/nginx/sites-available/nostalgix' do
  source 'nostalgix.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(:server_name => data_bag['server_name'])
  action :create
end

