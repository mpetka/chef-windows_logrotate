default['windows_logrotate']['version'] = '0.0.0.17_20170116'
default['windows_logrotate']['sha256'] = 'd82efafdf085ef98a72dade1c7ac66c303f8fa902a7a80a5dceba3062e0f07fb'
default['windows_logrotate']['install_dir'] = "#{ENV['SYSTEMDRIVE']}\\logrotate"
default['windows_logrotate']['zip_filename'] = "logrotateSetup_#{node['windows_logrotate']['version']}.zip"
default['windows_logrotate']['url'] = 'https://pilotfiber.dl.sourceforge.net/project' \
    "/logrotatewin/#{node['windows_logrotate']['zip_filename']}"
