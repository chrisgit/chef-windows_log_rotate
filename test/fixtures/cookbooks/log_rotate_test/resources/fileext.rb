provides :fileext, platform: 'windows'

property :file_name, String, required: true, name_property: true
property :ctime, [String ,DateTime, Time], default: ''

action :create do
  file file_name do
    action :create
  end

  unless ctime.is_a?(String) && ctime.empty?
    year, month, day = split_date
    powershell_script "set ctime #{file_name}" do
      code <<-EOH
      $(Get-Item #{file_name}).creationtime=$(Get-Date -Year #{year} -Month #{month} -Day #{day})
      EOH
    end
  end
end

def split_date
  return ctime.split('-') if ctime.is_a?(String)
  return ctime.year, ctime.month, ctime.day if ctime.is_a?(Time) || ctime.is_a?(DateTime)
end
