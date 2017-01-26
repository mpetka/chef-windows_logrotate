# Windows LogRotate Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/windows_logrotate.svg?style=flat-square)][cookbook]
[![Build Status](https://img.shields.io/appveyor/ci/dhoer/chef-windows_logrotate/master.svg?style=flat-square)][win]

[cookbook]: https://supermarket.chef.io/cookbooks/windows_logrotate
[win]: https://ci.appveyor.com/project/dhoer/chef-windows-logrotate

Installs/configures Ken Salter's 
[LogRotate for Windows](https://github.com/plecos/logrotatewin/).

This is a Windows implementation of the logrotate utility found in 
Linux platforms. 

Supported configuration file options: 
https://sourceforge.net/p/logrotatewin/wiki/LogRotate/#configuration-file


## Requirements

- Chef 12.6+
- .NET Framework v4.5

### Platform

- Windows

## Usage

Use windows_logrotate resource to install and configure logrotate, and 
create a scheduled task to run it periodically.

Example

```ruby
windows_logrotate 'logrotate test' do
  username user
  password pass
  run_immediately true
  sensitive false
  conf <<-EOF
missingok
compress
delaycompress
copytruncate
notifempty

C:\\test.log {
	rotate 5
	daily
	prerotate
		@echo off
		echo This is a test
		echo parameter pass %1
		VER | TIME > TEMP.BAT
		ECHO SET TIME=%%3>CURRENT.BAT
		DEL TEMP.BAT
		DEL CURRENT.BAT
		ECHO It's %TIME% now
	endscript
}
  EOF
end
```

Cookbook Matchers

- enable_windows_logrotate(servicename)

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/windows+logrotate).
- Report bugs and discuss potential features in [Github issues](https://github.com/dhoer/chef-windows_logrotate/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-nssm/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-nssm/blob/master/LICENSE.md) file for details.
