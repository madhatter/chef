package 'nginx' do
  action :install
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
end

