include_attribute "mongodb::mongodb"

# The following values must be defined by the role or environment
default[:db_server][:dns_name]  = ""

default[:db_server][:device]    = "/dev/sdf"
