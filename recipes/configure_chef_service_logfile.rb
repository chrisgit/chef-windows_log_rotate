# This recipe will direct all messages from Chef service to client.service.log file not client.log
# Thereby allowing easier capability for log rotate/daily log

# The code in Chef Client cookbook does one of two things
# 1. If Chef 12.5.1 or above Chef service uses a custom configuration
# 2. If Chef below 12.5.1 then Chef service log file is specified
# Code is below
=begin
d_owner = root_owner
install_command = "chef-service-manager -a install -c #{File.join(node['chef_client']['conf_dir'], 'client.service.rb')}"
if Chef::VERSION <= '12.5.1'
  install_command << " -L #{File.join(node['chef_client']['log_dir'], 'client.log')}"
end

template "#{node['chef_client']['conf_dir']}/client.service.rb" do
  source 'client.service.rb.erb'
  owner d_owner
  group node['root_group']
  mode '644'
end

execute 'register-chef-service' do
  command install_command
  not_if { chef_client_service_running }
end
=end
# One thing to note in the code above, the version check is STRING type, meaning 12.19.36 is less than 12.5.1

# If Chef client > 12.5.1 then specify a new client service template which include log file name
resources("template[#{node['chef_client']['conf_dir']}/client.service.rb]").cookbook('windows_logrotate')

# Chef rewind https://github.com/thommay/chef-rewind
# has been deprecated in favour of using edit_resource and delete_resource https://coderanger.net/rewind/
# However, if you are using Chef client < 12.10 then you have no choice but to continue to use rewind
# Chef service for Client < 12.5.1 will specify -L <log_file>
chef_version = Gem::Version.new(Chef::VERSION)
edit_resource_compat_version = Gem::Version.new('12.10.0')
service_config_compat_version = Gem::Version.new('12.5.1')

install_command = "chef-service-manager -a install -c #{File.join(node['chef_client']['conf_dir'], 'client.service.rb')}"
if chef_version <= service_config_compat_version
  install_command << " -L #{File.join(node['chef_client']['log_dir'], node['chef_client']['service_log_file'])}"
end

if chef_version >= edit_resource_compat_version
  # Use new edit_resource, NB: this resource is guarded with not_if so will never update if Chef service running
  # If Chef service already exists then you need to stop the service and remove it (sc delete "chef-client")
  edit_resource!(:execute, 'register-chef-service') do
    command install_command
  end
else
  # Use Chef rewind
  # NB: Latest version of chef-client uses custom resources so needs to be > 12.5.0 or use compact_resource
  # This cookbook itself requires the new custom resource capability too so code herein is for cut/paste purposes
  chef_gem 'chef-rewind'
  require 'chef/rewind'

  rewind 'execute[register-chef-service]' do
    command install_command
  end
end
