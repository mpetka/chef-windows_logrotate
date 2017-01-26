# Windows LogRotate Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/windows_logrotate.svg?style=flat-square)][cookbook]
[![Build Status](https://img.shields.io/appveyor/ci/dhoer/chef-windows_logrotate/master.svg?style=flat-square)][win]

[cookbook]: https://supermarket.chef.io/cookbooks/windows_logrotate
[win]: https://ci.appveyor.com/project/dhoer/chef-windows-logrotate

Installs/configures Ken Salter's 
[LogRotate for Windows](https://github.com/plecos/logrotatewin/).

This is a Windows implementation of the logrotate utility found in 
Linux platforms. The goal is to use the same command line parameters 
and files as the Linux version.

## Requirements

- Chef 12.6+
- .NET Framework v4.5

### Platform

- Windows

## Usage

Configure logrotate:

```ruby
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
