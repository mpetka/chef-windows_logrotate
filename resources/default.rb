actions :enable
default_action :enable

attribute :name, kind_of: String, name_attribute: true
attribute :username, kind_of: String, default: 'Administrator'
attribute :password, kind_of: [String, NilClass]
attribute :conf, kind_of: [Array, Hash], required: true

# conf can contain an hash or an array of hashes that contain
# attribute :path, kind_of: [String, Array], required: true
# attribute :frequency, kind_of: String, default: 'weekly'
# attribute :rotate, kind_of: Integer, default: 0
# attribute :options, kind_of: [Array, String], default: %w(missingok compress delaycompress copytruncate notifempty)

attribute :verbose, kind_of: [TrueClass, FalseClass], default: false
attribute :force, kind_of: [TrueClass, FalseClass], default: false
attribute :run_immediately, kind_of: [TrueClass, FalseClass], default: false

attribute :cookbook, kind_of: String, default: 'windows_logrotate'
attribute :conf_tmpl, kind_of: String, default: 'logrotate.conf.erb'
attribute :schtask_tmpl, kind_of: String, default: 'schtask.xml.erb'

attribute :sensitive, kind_of: [TrueClass, FalseClass] # , default: true - see initialize below

# Chef will override sensitive back to its global value, so set default to true in init
def initialize(*args)
  super
  @sensitive = true
end
