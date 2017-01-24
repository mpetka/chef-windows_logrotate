if defined?(ChefSpec)
  def enable_windows_logrotate(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_logrotate, :enable, resource_name)
  end

  def enable_windows_logrotate(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_logrotate, :disable, resource_name)
  end
end
