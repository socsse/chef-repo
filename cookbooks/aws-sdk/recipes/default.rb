#
# Cookbook Name:: aws-sdk
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# packages needed to require Nokogirl
package "libxslt-dev libxml2-dev"

gem_package "aws-sdk" do
  action :install
end

