current_dir = File.dirname(__FILE__)

log_level                :info
log_location             STDOUT
node_name                "#{ENV['CHEF_USER_NAME']}"
client_key               "#{ENV['CHEF_USER_KEY']}"
validation_client_name   "socsse-validator"
validation_key           "#{ENV['CHEF_VALIDATION_KEY']}"
chef_server_url          "https://api.opscode.com/organizations/socsse"
cache_type               "BasicFile"
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]

knife[:aws_access_key_id]     = "#{ENV['EC2_ACCESS_KEY']}" 
knife[:aws_secret_access_key] = "#{ENV['EC2_SECRET_KEY']}"
knife[:aws_ssh_key_id]        = "chef-knife"
knife[:flavor]                = "m1.small"
