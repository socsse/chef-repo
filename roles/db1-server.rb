name "db1-server"
description "Set node up as a mongo server, assigns it as db1"
override_attributes(
  :active_groups => ["developer", "mongodb"],
  :set_hostname => {
    :databag => "db1-server-host"
  },
  :mongodb => {
    :server => {
      :dbpath => "/data/db",
      :port => 27017,
      :replSet => "cmom_dbset"
    }
  }
)
run_list(
  "role[base]",
  "recipe[set-hostname]",
  "recipe[users]",
  "recipe[db-server]"
)
