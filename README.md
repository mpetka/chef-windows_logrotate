# Windows LogRotate Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/windows_logrotate.svg?style=flat-square)][cookbook]
[![Build Status](https://img.shields.io/appveyor/ci/dhoer/chef-windows-logrotate/master.svg?style=flat-square)][win]

[cookbook]: https://supermarket.chef.io/cookbooks/windows_logrotate
[win]: https://ci.appveyor.com/project/dhoer/chef-windows-logrotate

Installs/configures Ken Salter's 
[LogRotate for Windows](https://github.com/plecos/logrotatewin/).

This is a Windows implementation of the logrotate utility found in 
Linux platforms. 

Supported logrotate configuration options: 
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
C:\\test.log {
    missingok
    compress
    delaycompress
    copytruncate
    notifempty
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

### Attributes

* `name` -  The name of logrotate configuration file to create. 
Defaults to resource block name.
* `username` -  The username to create scheduled task as. 
Default: `Administrator`.
* `password` - Required to create scheduled task. 
* `conf` - Required logroate configuration. 
* `verbose` - Turns on verbose mode. Sensitive will need to be false in
order to see output.
* `force` - Tells logrotate to force the rotation, even if it doesn't 
think this is necessary. Sometimes this is useful after adding new 
entries to a logrotate config file, or if old log files have been 
removed by hand, as the new files will be created, and logging will 
continue correctly.
* `run_immediately` - Runs scheduled task immediately after creating or 
updating logrotate configuration.
* `cookbook` - The cookbook that contains the template for 
logrotate conf. Users can provide their own template by setting this 
attribute to point at a different cookbook. 
Default: `windows_logrotate`.
* `conf_tmpl` - Sets the conf template source. 
Default: `logrotate.conf.erb`.
* `schtask_tmpl` - Sets the schtask template source. 
Default: `schtask.xml.erb`.
* `sensitive` - Suppress logging sensitive information.  
Default: `true`.

## ChefSpec Matchers

This cookbook includes custom 
[ChefSpec](https://github.com/sethvargo/chefspec) matchers you can 
use to test your own cookbooks.

Example Matcher Usage

```ruby
expect(chef_run).to enable_windows_logrotate('resource_name')
```

Cookbook Matchers

- enable_windows_logrotate(resource_name)

## Getting Help

- Ask specific questions on 
[Stack Overflow](http://stackoverflow.com/questions/tagged/windows+logrotate).
- Report bugs and discuss potential features in 
[Github issues](https://github.com/dhoer/chef-windows_logrotate/issues).

## Contributing

Please refer to 
[CONTRIBUTING](https://github.com/dhoer/chef-windows_logrotate/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying 
[LICENSE](https://github.com/dhoer/chef-windows_logrotate/blob/master/LICENSE.md) 
file for details.
