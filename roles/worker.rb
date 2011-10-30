name "worker"
description "Set node up as a worker"
override_attributes(
  :active_groups => ["developer", "worker"]
)
run_list(
  "role[base]",
  "recipe[users]",
  "recipe[worker]"
)
