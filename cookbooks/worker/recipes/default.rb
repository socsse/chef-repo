#
# Cookbook Name:: worker
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# TODO: Change file/directory permissions before production

include_recipe "aws-sdk"
include_recipe "mongodb::apt"

aws_main = data_bag_item( "aws", "main" )
# TODO: Should raise exeception if not found

gem_package "json" do
  action :install
end

gem_package "mongo" do
  action :install
end

gem_package "bson_ext" do
  action :install
end

worker_dir = node[:worker][:dir]
directory worker_dir do
  owner "worker"
  group "worker"
  mode "0777"
  recursive true
end

template "#{worker_dir}/worker_config.rb" do
  source "worker_config.erb"
  owner "worker"
  group "worker"
  mode 0440
  variables(
    :aws_access_key => aws_main[ "aws_access_key_id" ],
    :aws_secret_access_key => aws_main[ "aws_secret_access_key" ],
    :job_status_queue => node[:worker][:job_status_queue],
    :job_todo_queue => node[:worker][:job_todo_queue],
    :job_todo_queue_poll_frequency => node[:worker][:job_todo_queue_poll_frequency]
  )
end

cookbook_file "#{worker_dir}/worker.rb" do
  source "worker.rb"
  owner "worker"
  group "worker"
  mode 0777
end

worker_logdir = node[:worker][:logdir]
directory worker_logdir do
  owner "worker"
  group "worker"
  mode "0777"
  recursive true
end



