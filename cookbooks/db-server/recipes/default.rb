#
# Cookbook Name:: db-server
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# raise "Must specify a DNS Name for this DB Server" unless !node[:db_server][:dns_name].empty?

include_recipe "aws"
include_recipe "xfs"

aws_main = data_bag_item( "aws", "main" )

dev_name = node[ :db_server ][ :device ]
log "DevName = #{dev_name}"

aws_ebs_volume "db_ebs_volume" do
  aws_access_key aws_main[ "aws_access_key_id" ]
  aws_secret_access_key aws_main[ "aws_secret_access_key" ]
  size 10
  device dev_name
  action [ :create, :attach ]
end

log "MKMS DevName = #{dev_name}"
execute "mkfs.xfs" do
  command "mkfs.xfs #{dev_name}"
end

db_path  = node[:mongodb][:server][:dbpath]
log "DBPath = #{db_path}"

directory db_path do
  owner "mongodb"
  group "mongodb"
  mode "0755"
  recursive true
end

mount db_path do
  device dev_name
  fstype  "xfs"
  options "noatime,noexec,nodiratime"
  action [ :enable, :mount ]
end

include_recipe "mongodb::apt"
include_recipe "mongodb::server"

