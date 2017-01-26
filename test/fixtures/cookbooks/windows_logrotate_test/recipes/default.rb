cookbook_file "#{ENV['SYSTEMDRIVE']}\\test.log" do
  source 'test.log'
  action :create
end

windows_logrotate 'logrotate test' do
  username node['windows_logrotate_test']['username']
  password node['windows_logrotate_test']['password']
  run_immediately true
  sensitive false
  conf [
    {
      path: 'C:\test.log',
      frequency: 'daily',
      rotate: 5,
      options: %w(missingok compress delaycompress copytruncate notifempty),
      postrotate: <<-EOF
        @echo off
        echo This is a test
        echo parameter pass %1
        VER | TIME > TEMP.BAT
        ECHO SET TIME=%%3>CURRENT.BAT
        DEL TEMP.BAT
        DEL CURRENT.BAT
        ECHO It's %TIME% now
      EOF
    }
  ]
end
