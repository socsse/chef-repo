name "web-server"
description "Setup server for running web applications"
override_attributes(
  :active_groups => ["developer", "www-data"]
)
run_list(
  "role[base]",
  "recipe[users]",
  "recipe[passenger]"
)
