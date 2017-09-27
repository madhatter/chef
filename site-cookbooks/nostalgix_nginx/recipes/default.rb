package 'nginx' do
  action :install
end

group 'www-data' do
  action :modify
  members 'maintenance'
  append true
end

['/etc/nginx/sites-available', '/etc/nginx/sites-enabled'].each do |dir|
  directory "#{dir}" do
    action :create
    owner 'root'
    group 'root'
    mode '0755'
  end
end

link '/etc/nginx/sites-enabled/default' do
  action :delete
end

cookbook_file '/etc/nginx/nginx.conf' do
  source 'nginx.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
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

  link "/etc/nginx/sites-enabled/#{site}" do
    to "/etc/nginx/sites-available/#{site}"
    link_type :symbolic
  end

  directory "#{data_bag['root_dir']}" do
    owner 'www-data'
    group 'www-data'
    mode '0755'
  end
end

