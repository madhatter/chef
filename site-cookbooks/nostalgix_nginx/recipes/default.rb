data_bag = data_bag_item('nginx', 'nostalgix')

package 'nginx' do
  action :install
end

template '/etc/nginx/sites-available/nostalgix' do
  source 'site.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(:data_bag => data_bag)
  action :create
end

