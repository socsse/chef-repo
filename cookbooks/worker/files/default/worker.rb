#!/usr/local/bin/ruby

require_relative 'worker_config'

require 'aws'
require 'json'

# Make sure stdout and stderr write out without delay for using with daemon like scripts
STDOUT.sync = true; STDOUT.flush
STDERR.sync = true; STDERR.flush

AWS.config(
  :access_key_id => AWS_ACCESS_KEY,
  :secret_access_key => AWS_SECRET_ACCESS_KEY)

# ------------------------------------ process a job

# grab queues
sqs = AWS::SQS.new

status_queue = sqs.queues.create(JOB_STATUS_QUEUE)
todo_queue = sqs.queues.create(JOB_TODO_QUEUE)

todo_queue.poll do |msg|

  job_params = JSON.parse(msg.body)

  # read job configuration data

  s3 = AWS::S3.new
  bucket = s3.buckets[job_params["bucket_name"]]

  config_file = job_params["config_file"]
  config_obj  = bucket.objects[config_file]
  config_data = JSON.parse(config_obj.read)

  # send start message

  msg = Hash.new
  msg[:msg_type] = "job_status"
  msg[:msg_time] = Time.now

  msg[:user_id] = config_data["user"]["id"]
  msg[:chip_id] = config_data["user"]["chip"]["id"]

  msg[:status] = "running"

  status_queue.send_message(msg.to_json)

  # simulate job time

  sleep 10

  # write job output files (example)

  output_object_name = File.join(File.dirname(config_file), "output.html")
  s3_object = bucket.objects[output_object_name]
  s3_object.write("<p>This should contain information about the job with links to different output files.</p>")

  output_file = s3_object.url_for(:read, :expires => OUTPUT_URL_EXPIRATION).to_s

  # notify web-app we are done

  msg = Hash.new
  msg[:msg_type] = "job_status"
  msg[:msg_time] = Time.now

  msg[:user_id] = config_data["user"]["id"]
  msg[:chip_id] = config_data["user"]["chip"]["id"]

  msg[:status]      = "finished"
  msg[:output_file] = output_file

  status_queue.send_message(msg.to_json)

  # send email to user

  ses = AWS::SimpleEmailService.new
  ses.send_email(
    :subject => "Job to Create Chip '<name>' Completed",
    :from => "ken@kjoyner.com",
    :to => "ken@kjoyner.com",
    :body_html => "<h1>Chip '<name>'</h1><p>Output file = #{output_file}")

  # clean-up job data
  config_obj.delete

end
