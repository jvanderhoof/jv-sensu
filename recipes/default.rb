#
# Cookbook Name:: jv-sensu
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

node.default['sensu']['use_embedded_ruby'] = true
node.default['sensu']['dashboard']['user'] = 'admin'
node.default['sensu']['dashboard']['password'] = 'iforget'

include_recipe 'sensu::default'
include_recipe 'sensu::rabbitmq'
include_recipe 'sensu::redis'
include_recipe 'sensu::server_service'
include_recipe 'sensu::api_service'
include_recipe 'sensu::dashboard_service'


sensu_handler "graphite" do
  type "tcp"
  socket(host: '10.10.20.16', port: 2003 )
  mutator 'only_check_output'
end

[
  ['cpu-usage-metrics.sh', 10], 
  ['memory-metrics.rb', 10], 
  ['disk-metrics.rb', 30], 
  ['disk-capacity-metrics.rb', 60]
].each do |metric|
  sensu_plugin "https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/#{metric[0]}"
  sensu_check metric[0].split('.')[0] do
    type 'metric'
    command metric[0]
    handlers ['graphite']
    subscribers ['system']
    interval metric[1]
  end
end


include_recipe 'sensu::client_service'

sensu_client node.name do
  address '127.0.0.1'
  subscriptions node.roles + ["system"]
end
