if platform?('windows')
  cache_path = "#{Chef::Config[:file_cache_path]}\\#{node['windows_logrotate']['zip_filename']}"

  remote_file "download #{node['windows_logrotate']['url']}" do
    path cache_path
    source node['windows_logrotate']['url']
    checksum node['windows_logrotate']['sha256']
    notifies :run, "powershell_script[unzip #{cache_path}]", :immediately
  end

  powershell_script "unzip #{cache_path}" do
    code "Add-Type -A 'System.IO.Compression.FileSystem';" \
      " [IO.Compression.ZipFile]::ExtractToDirectory('#{cache_path}', '#{Chef::Config[:file_cache_path]}');"
    action :nothing
    notifies :install, 'windows_package[logrotateSetup.exe]', :immediately
  end

  windows_package 'logrotateSetup.exe' do
    installer_type :custom
    options "/S /v\"/qn\" /v\"INSTALLDIR=#{node['windows_logrotate']['install_dir']}\""
    source "#{Chef::Config[:file_cache_path]}\\logrotateSetup.exe"
    action :nothing
  end
else
  Chef::Log.warn('LogRotate for Windows can only be installed on Windows platforms!')
end
