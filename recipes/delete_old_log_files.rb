archive_files 'delete_old_log_files' do
  filemask "#{node['windows_logrotate']['log_file']}.*"
  fileage node['windows_logrotate']['days_to_keep_logs']
  action :delete
end
