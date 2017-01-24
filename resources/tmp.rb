resource_name :windows_logrotate_tmp

property :path, [String, Array], required: true
property :username, String, default: 'Administrator'
property :password, [String, NilClass]
property :frequency, String, default: 'weekly'
property :rotate, Integer, default: 0
property :options, [Array, String], default: %w(missingok compress delaycompress copytruncate notifempty)
property :verbose, [TrueClass, FalseClass], default: false
property :debug, [TrueClass, FalseClass], default: false
property :force, [TrueClass, FalseClass], default: false
property :sensitive, [TrueClass, FalseClass]

property :cookbook, default: 'windows_logrotate'
property :conf_tmpl, default: 'logrotate.conf.erb'
property :schtask_tmpl, default: 'schtask.xml.erb'

default_action :enable

action :enable do
  unless run_context.loaded_recipe? 'windows_logrotate::default'
    recipe_eval do
      run_context.include_recipe 'windows_logrotate::default'
    end
  end

  @sensitive = sensitive

  logrotate_conf = {
    # The path should be a space separated list of quoted filesystem paths
    path: Array(new_resource.path).map { |path| path.to_s.inspect }.join(' '),
    frequency: new_resource.frequency,
    # directives: handle_options(new_resource),
    # scripts: handle_scripts(new_resource),
    # configurables: handle_configurables(new_resource),
  }

  conf_path = "#{node['windows_logrotate']['install_dir']}\\Content\\#{new_resource.name}.conf"

  template conf_path do
    source new_resource.conf_tmpl
    cookbook new_resource.cookbook
    variables logrotate_conf
    notifies :run, "execute[schtask #{new_resource.name}]", :delayed
  end

  schtask_conf = {
    username: new_resource.username,
    command: "#{node['windows_logrotate']['install_dir']}\\logrotate.exe",
    arguments: "-s \"#{node['windows_logrotate']['install_dir']}\\logrotate.status\" #{verbose(new_resource)}" \
        "\"#{conf_path}\"",
    working_directory: node['windows_logrotate']['install_dir']
  }

  schtask_path = "#{node['windows_logrotate']['install_dir']}\\Content\\#{new_resource.name}.xml"

  template schtask_path do
    source new_resource.schtask_tmpl
    cookbook new_resource.cookbook
    variables schtask_conf
    notifies :run, "execute[schtask #{new_resource.name}]", :delayed
  end

  execute "schtask #{new_resource.name}" do
    sensitive new_resource.sensitive
    command "schtasks /Create /F /TN \"#{new_resource.name}\" /XML \"#{schtask_path}\" /NP " \
        "/RU \"#{new_resource.username}\" /RP \"#{new_resource.password}\""
    # action :nothing
  end
end

# action :disable do
#   file "#{node['windows_logrotate']['install_dir']/#{new_resource.name}" do
#     action :delete
#   end
# end

def verbose(new_resource)
  if  new_resource.verbose
    '-v '
  else
    ''
  end
end
