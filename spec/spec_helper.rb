# Added by ChefSpec
require 'chefspec'
require 'chefspec/berkshelf'

CACHE = Chef::Config[:file_cache_path]
VERSION = '0.0.0.17_20170116'.freeze

ChefSpec::Coverage.start!
