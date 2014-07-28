sensu_asset "https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/check-mem.sh" do
  asset_directory File.join(node.sensu.directory, "plugins")
end

sensu_check "check_memory" do
  command File.join(node.sensu.directory, "plugins", 'check-mem.sh -w 512 -c 768 -p')
  handlers ["default"]
  subscribers ["system"]
  interval 10
  additional(:notification => "Memory usage is too high", :occurrences => 5)
end