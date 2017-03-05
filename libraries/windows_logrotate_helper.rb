# Windows Log Rotate module
module Windows
# Module used as namespace to help classify code
  module Logging
    require 'date'

    def self.chef_logger(log_type, log_location, shift_age)
      if log_type == 'daily_log'
        daily_log_rotate(log_location)
      else
        ruby_log_rotate(log_location, shift_age)
      end
    end

    private_class_method

    def self.ruby_log_rotate(log_location, shift_age)
      Chef::Log.init(Logger.new(log_location, shift_age))
      Chef::Log.level = log_level_configuration
      inform_logger_changed('Chef logger changed to Ruby Log Rotate')
    end

    def self.daily_log_rotate(log_location)
      Chef::Log.init(MonoLogger.new("#{log_location}.#{format_todays_date}"))
      Chef::Log.level = log_level_configuration
      inform_logger_changed('Chef logger changed to Daily Log Rotate')
    end

    def self.log_level_configuration
      Chef::Config[:log_level].nil? || Chef::Config[:log_level] == :auto ? :info : Chef::Config[:log_level]
    end

    def self.inform_logger_changed(message)
      Chef::Log.warn("#{message} #{Chef::Log.loggers[0]}")
    end

    def self.format_todays_date()
      DateTime.now.strftime('%Y%m%d')
    end
  end
end
