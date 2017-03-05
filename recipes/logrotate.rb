# Log rotate

# Create folder to hold the log file
directory File.dirname(node['windows_logrotate']['log_file']) do
  recursive true
  action :nothing
end.run_action(:create)

log_type = node['windows_logrotate']['log_type']
log_location = node['windows_logrotate']['log_file']
shift_age = node['windows_logrotate']['days_to_keep_logs']

::Windows::Logging.chef_logger(log_type, log_location, shift_age)
