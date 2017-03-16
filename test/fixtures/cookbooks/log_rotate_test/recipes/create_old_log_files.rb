# Create some files for archive
fileext "#{node['windows_logrotate']['log_file']}.20170101" do
  ctime '2017-01-01'
  action :nothing
end.run_action(:create)

fileext "#{node['windows_logrotate']['log_file']}.20170102" do
  ctime '2017-01-02'
  action :nothing
end.run_action(:create)

# Create a file that will not be archived
file "#{node['windows_logrotate']['log_file']}.new" do
  action :nothing
end.run_action(:create)
