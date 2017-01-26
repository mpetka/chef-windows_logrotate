require 'spec_helper'

describe 'windows_logrotate::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      file_cache_path: CACHE, platform: 'windows', version: '2008R2'
    ).converge(described_recipe)
  end

  it 'downloads logrotateSetup' do
    expect(chef_run).to create_remote_file(
      "download https://pilotfiber.dl.sourceforge.net/project/logrotatewin/logrotateSetup_#{VERSION}.zip"
    ).with(
      path: "#{CACHE}\\logrotateSetup_#{VERSION}.zip",
      source: "https://pilotfiber.dl.sourceforge.net/project/logrotatewin/logrotateSetup_#{VERSION}.zip"
    )
  end

  it 'unzips logrotateSetup' do
    expect(chef_run).to_not run_powershell_script("unzip #{CACHE}\\logrotateSetup_#{VERSION}.zip")
  end

  it 'install logrotateSetup' do
    expect(chef_run).to_not install_windows_package('logrotateSetup.exe')
  end
end
