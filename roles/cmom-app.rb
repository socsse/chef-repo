name "cmom-app"
description "Setup web-server to run the cMoM Rails application"
override_attributes(
  :active_groups => ["app"]
)
run_list(
  "role[web-server]",
  "recipe[users]",
  "recipe[mongodb::apt]",
  "recipe[cmom-app]"
)
