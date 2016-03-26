#
# Cookbook Name: docker
# Recipe: default
#
# Installs base docker setup
#

package 'docker' do
  action :install
end

directory '/etc/conf.d' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template '/etc/conf.d/docker' do
  source 'docker_conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

# Remove all stopped containers once in a while
cron 'Remove old docker containers' do
  command 'docker ps -q | xargs docker stop || docker ps -a -q | xargs docker rm >/var/log/docker_cleanup_old_containers.log 2>&1'
  minute '0'
  hour '10,22'
  weekday '1'
  user 'root'
end

cron 'Remove dangling docker images' do
  command  'docker images -q -f dangling=true | xargs docker rmi >/var/log/docker_cleanup_dangling_images.log 2>&1'
  minute '0'
  hour '9,21'
  weekday '*'
  user 'root'
end

cron 'Remove untagged docker images' do
  command  'docker images | grep "^<none>" | awk \'{print $3}\' | xargs docker rmi >/var/log/docker_cleanup_untagged_images.log 2>&1'
  minute '30'
  hour '9,21'
  weekday '*'
  user 'root'
end
