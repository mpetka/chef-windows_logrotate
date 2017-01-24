cookbook_file "#{ENV['SYSTEMDRIVE']}\\test.log" do
  source 'test.log'
  action :create
end

windows_logrotate 'logrotate test' do
  username 'vagrant'
  password 'vagrant'
  path 'C:\test.log'
  frequency 'daily'
  rotate 30
end
