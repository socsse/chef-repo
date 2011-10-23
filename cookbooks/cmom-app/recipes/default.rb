#
# Cookbook Name:: cmom-app
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"

directory "/var/www/cMoM" do
  group "www-data"
  mode  "775"
  owner "app"
end

web_app "cMoM" do
  docroot "/var/www/cMoM/current/public"
  server_aliases [node['fqdn'], "cmom.solots.com"]
  server_name "solots.com"
end

gem_package "bundler" do
  action :install
end
