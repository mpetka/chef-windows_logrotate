require 'serverspec_helper'

describe 'windows_logrotate' do
  describe file('C:\logrotate\logrotate.exe') do
    it { should be_file }
  end

  describe file('C:\logrotate\scheduler.xml') do
    it { should be_file }
  end

  describe file('C:\logrotate\Content\logrotate.conf') do
    it { should be_file }
  end
end
