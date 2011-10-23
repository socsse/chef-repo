#
# Cookbook Name:: set-hostname
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "aws"

host_info_db = node[:set_hostname][:databag]
# TODO: Should verify this exists since client must set

host_info = data_bag_item( "aws", host_info_db )

fqdn = host_info[ "fqdn" ]
hostname = host_info[ "hostname" ]

ruby_block "edit /etc/hosts" do
  block do
    rc = Chef::Util::FileEdit.new( "/etc/hosts" )
    rc.search_file_replace_line( /^127\.0\.0\.1 localhost$/, "127.0.0.1 #{fqdn} #{hostname} localhost" )
    rc.write_file
  end
end

execute "hostname --file /etc/hostname" do
  action :nothing
end

file "/etc/hostname" do
  content hostname
  notifies :run, resources( :execute => "hostname --file /etc/hostname" ), :immediately
end

execute "/etc/init.d/hostname start" do

end

node.automatic_attrs["hostname"] = hostname
node.automatic_attrs["fqdn"] = fqdn

# public_ip = host_info[ "public_ip" ]

# aws_main = data_bag_item( "aws", "main" )

#aws_elastic_ip "elastic_ip" do
#  aws_access_key aws_main[ "aws_access_key_id" ]
#  aws_secret_access_key aws_main[ "aws_secret_access_key" ]
#  ip public_ip
#  action :associate
#end
