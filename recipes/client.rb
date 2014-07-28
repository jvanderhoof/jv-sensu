sensu_client node.name do
  address '127.0.0.1'
  subscriptions node.roles + ["all"]
end

include_recipe 'sensu::client_service'

#include_recipe 'jv-sensu::system_checks'

