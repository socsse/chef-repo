#
# Cookbook Name:: cmom-app
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
include_recipe "aws"

APP_DIR = "/var/www/cMoM"
SHARED_CONFIG_DIR = "#{APP_DIR}/shared/config"

# TODO: Should raise exeception if not found
aws_main = data_bag_item( "aws", "main" )

# create both the app directory and the shared config directory
directory SHARED_CONFIG_DIR do
  owner "app"
  group "www-data"
  mode  "775"
  recursive true
end

template "#{SHARED_CONFIG_DIR}/broker.yml" do
  source "broker.yml.erb"
  owner "app"
  group "www-data"
  mode 0400
  variables(
    :aws_access_key_id => aws_main[ "aws_access_key_id" ],
    :aws_secret_access_key => aws_main[ "aws_secret_access_key" ]
  )
end

web_app "cMoM" do
  docroot "/var/www/cMoM/current/public"
  server_aliases [node['fqdn'], "cmom.solots.com"]
  server_name "solots.com"
end

gem_package "bundler" do
  action :install
end
