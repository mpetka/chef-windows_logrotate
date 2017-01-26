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

  content_dir = "#{node['windows_logrotate']['install_dir']}\\Content"
  conf_path = "#{content_dir}\\#{new_resource.name}.conf"

  template conf_path do
    source new_resource.conf_tmpl
    cookbook new_resource.cookbook
    variables confs: new_resource.conf.is_a?(Array) ? new_resource.conf : Array(new_resource.conf)
    notifies :run, "execute[schtask #{new_resource.name}]", :delayed
  end

  state_path = "#{content_dir}\\#{new_resource.name}.status"

  schtask_conf = {
    username: new_resource.username,
    command: "#{node['windows_logrotate']['install_dir']}\\logrotate.exe",
    arguments: "#{verbose_flag}#{force_flag}-s \"#{state_path}\" \"#{conf_path}\"",
    working_directory: content_dir
  }

  schtask_path = "#{content_dir}\\#{new_resource.name}.xml"

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
    notifies :run, "execute[run schtask #{new_resource.name} immediately]", :immediately
  end

  execute "run schtask #{new_resource.name} immediately" do
    sensitive new_resource.sensitive
    command "schtasks /Run /TN \"#{new_resource.name}\" "
    action :nothing
    only_if { new_resource.run_immediately }
  end
end

def force_flag
  if new_resource.force
    '-f '
  else
    ''
  end
end

def verbose_flag
  if new_resource.verbose
    '-v '
  else
    ''
  end
end
