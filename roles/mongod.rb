name "mongod"
description "Set node up as a mongo server"
default_attributes(
  :mongodb => {
    :server => {
      :dbpath => "/data/db",
      :replSet => "cmom_mongodb"
    }
  }
)
run_list(
  "recipe[mongodb::default]"
)
