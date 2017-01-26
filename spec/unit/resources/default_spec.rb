require 'spec_helper'

describe 'windows_logrotate_test::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      file_cache_path: CACHE, platform: 'windows', version: '2008R2', step_into: 'windows_logrotate'
    ) do |node|
      node.override['windows_logrotate_test']['username'] = 'vagrant'
      node.override['windows_logrotate_test']['password'] = 'vagrant'
      ENV['SYSTEMDRIVE'] = 'C:'
    end.converge(described_recipe)
  end

  it 'create test log' do
    expect(chef_run).to create_cookbook_file('C:\test.log')
  end

  it 'install logrotate' do
    expect(chef_run).to enable_windows_logrotate('logrotate test')
  end

  it 'create conf' do
    expect(chef_run).to create_template('C:\logrotate\Content\logrotate test.conf')
  end

  it 'configure schedule task' do
    expect(chef_run).to create_template('C:\logrotate\Content\logrotate test.xml')
  end

  it 'create schedule task' do
    expect(chef_run).to_not run_execute('schtask logrotate test')
  end

  it 'run schedule task' do
    expect(chef_run).to_not run_execute('run schtask logrotate test immediately')
  end
end
