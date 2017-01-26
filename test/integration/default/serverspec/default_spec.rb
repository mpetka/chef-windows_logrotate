require 'serverspec_helper'

describe 'windows_logrotate' do
  describe file('C:\logrotate\logrotate.exe') do
    it { should be_file }
  end

  describe file('C:\logrotate\logrotate.status') do
    it { should be_file }
  end

  describe file('C:\logrotate\Content\logrotate test.xml') do
    it { should be_file }
  end

  describe file('C:\logrotate\Content\logrotate test.conf') do
    it { should be_file }
  end

  describe file('C:\test.log') do
    it { should_not be_file }
  end

  describe file('C:\test.log.1') do
    it { should be_file }
  end
end
