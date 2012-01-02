
default[:worker][:dir]     = "/opt/worker"
default[:worker][:logdir]  = "/var/log/worker"

default[:worker][:job_status_queue] = "CMoMJobStatusQueue"
default[:worker][:job_todo_queue]   = "CMoMJobTodoQueue"
default[:worker][:job_todo_queue_poll_frequency] = 10

# number of seconds when the output_url should expire
default[:worker][:output_url_expiration] = 5184000
