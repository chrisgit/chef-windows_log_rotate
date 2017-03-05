resource_name :archive_files

property :filemask, String, default: '', required: true # name_property: true
property :fileage, Integer, default: 7, required: true
property :destination_path, String, default: ''

SECONDS_IN_DAY = 24 * 3600

action :delete do
  return unless filemask_validated()
  return unless fileage_validated()
  aged_files.each do |filename|
    file filename do
      backup false
      action :delete
    end
  end
end

action :move do
  return unless filemask_validated()
  return unless fileage_validated()
  return unless destination_path_validated()

  directory destination_path do
     recursive true
     action :create
   end

  aged_files.each do |filename|
    new_file = ::File.join(destination_path, ::File.basename(filename))
    file new_file do
      backup false
      content IO.read(filename)
      action :create
    end

    file filename do
      backup false
      action :delete
    end
  end
end

def filemask_validated()
  return true unless filemask.nil? || filemask.empty?
  Chef::Log.warn 'Archive files, no filemask set, cannot archive'
  false
end

def destination_path_validated()
  return true unless destination_path.nil? || destination_path.empty?
  Chef::Log.warn 'Archive Files, no destination path set, cannot archive'
  false
end

def fileage_validated()
  return true unless fileage.nil? || fileage < 0
  Chef::Log.warn 'Archive Files, no fileage set, cannot archive'
  false
end

def file_age_in_days(filename)
  ((time_now - ::File.ctime(filename)) / SECONDS_IN_DAY).to_i
end

def aged_files()
  Dir[filemask].select do |filename|
    file_age_in_days(filename) > fileage
  end
end

def time_now
  @time_now ||= Time.now
end
