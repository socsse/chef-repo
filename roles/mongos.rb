name "mongos"
description "Set node up with mongos daemon to communicate with mongod nodes"
default_attributes(
  :mongodb => {
    :cluster_name => "cmom_mongodb"
  }
)
run_list(
  "recipe[mongodb::10gen_repo],
  "recipe[mongodb::mongos]"
)
