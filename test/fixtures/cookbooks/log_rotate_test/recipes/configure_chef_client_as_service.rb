# Example to setup Chef client for Windows
# However you should really consider running Chef-Client for Windows as a schedule task
# Calling the default recipe of the latest version of Chef-Client community cookbook will do that for you (code below)
=begin
if platform?('windows')
  include_recipe 'chef-client::task'
else
  include_recipe 'chef-client::service'
end
=end

# This is demonstrating seperating log file for Chef service and Chef client on legacy installs
include_recipe 'chef-client::config'
include_recipe 'chef-client::service'
