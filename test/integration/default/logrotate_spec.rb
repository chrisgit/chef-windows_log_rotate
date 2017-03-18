# http://inspec.io/docs/reference/resources/file/

# Files removed by delete_old_logfiles
describe file('c:\chef\log\client.log.20170101') do
  it { should_not exist }
end

describe file('c:\chef\log\client.log.20170102') do
  it { should_not exist }
end

# Files left by delete_old_logfiles
describe file('c:\chef\log\client.log.new') do
  it { should exist }
end

# File created by daily log file functionality
describe file('c:\chef\log\client.log.20170201') do
  it { should exist }
end

# Chef client running as a service
describe service('chef-client') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# Chef service using different log from Chef-client
describe file('c:\chef\log\client.service.log') do
  it { should exist }
end
