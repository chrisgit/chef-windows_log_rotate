name             'windows_logrotate'
maintainer       'Chris Sullivan'
maintainer_email ''
license          'All rights reserved'
description      'Adds log rotate or daily log for Windows'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'
issues_url       '' if respond_to?(:issues_url)
source_url       '' if respond_to?(:source_url)
supports         'windows'

recipe           'default', 'Controls the basic run list'
recipe           'logrotate', 'Creates daily log file or Ruby logger with shift age specified'
recipe           'delete_old_log_files', 'Deletes files (based on creation time) when they reach a certain age'

# Extended definitions
grouping 'windows_log_rotate',
  title: 'Demonstration cookbook with code to switch loggers'

attribute 'windows_logrotate/log_type',
  required: 'required',
  type: 'string',
  default: 'daily_log',
  choices: [
    'daily_log',
    'rotate_log'
  ],
  recipes: ['windows_logrotate::logrotate']

attribute 'windows_logrotate/log_file',
  required: 'required',
  type: 'string',
  default: 'c:/chef/log/client.log',
  recipes: ['windows_logrotate::logrotate']
