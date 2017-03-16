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
