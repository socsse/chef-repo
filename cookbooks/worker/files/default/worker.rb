#!/usr/bin/ruby

require "worker_config"
#require 'rubygems'
require 'aws'

# Make sure stdout and stderr write out without delay for using with daemon like scripts
STDOUT.sync = true; STDOUT.flush
STDERR.sync = true; STDERR.flush

# ------------------------------------ helper methods

# convert key, pair values in string to hash
def to_h(m)
  kv = Array.new
  kvs = Array.new
  key_values = Hash.new
  m.each do |l|
    l.strip!
    kv = l.split(': ', 2)
    kv.each { |s| s.strip! }
    kvs << kv
  end
  key_values = kvs.inject({}) do |hash, value|
	  hash[value.first] = value.last 
	  hash
	end
  return key_values
end

# ------------------------------------ process a job

# grab queues
sqs = Aws::SqsGen2.new( AWS_ACCESS_KEY, AWS_SECRET_ACCESS_KEY )
job_queue = sqs.queue( JOB_QUEUE )

while true
  begin
    # read a single message (if any) and set MessageVisibility on it
    msg = jobs_queue.receive
    
    # if we didn't receive message check again later
    if msg.nil? 
      sleep JOB_QUEUE_POLL_FREQUENCY
    else 
      # record time message read
      msg_time_read = Time.now.httpdate

      # convert message to a Hash
      puts "message body:\n"
      puts msg.body
      job = to_h( msg.body )
      puts "job:\n"
      puts job

      # delete message from todo queue
      m.delete
    end
  end
end
