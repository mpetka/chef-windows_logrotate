use_inline_resources

def whyrun_supported?
  true
end

action :enable do
  unless run_context.loaded_recipe? 'windows_logrotate::default'
    recipe_eval do
      run_context.include_recipe 'windows_logrotate::default'
    end
  end

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
    arguments: "#{verbose_flag}#{force_flag} \"#{conf_path}\"",
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
    action :nothing
  end
end

# action :disable do
#   file "#{node['windows_logrotate']['install_dir']/#{new_resource.name}" do
#     action :delete
#   end
# end

def force_flag
  if  new_resource.verbose
    '-f '
  else
    ''
  end
end

def verbose_flag
  if  new_resource.verbose
    '-v '
  else
    ''
  end
end
