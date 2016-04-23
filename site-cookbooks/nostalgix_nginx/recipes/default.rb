package 'nginx' do
  action :install
end

node['nginx']['sites'].each do |site| 
  data_bag = data_bag_item('nginx', site)
  
  template "/etc/nginx/sites-available/#{site}" do
    source 'site.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(:data_bag => data_bag)
    action :create
  end
end
