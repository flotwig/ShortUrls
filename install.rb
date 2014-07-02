#/usr/bin/env ruby
# encoding: UTF-8
require 'sequel'
require 'yaml'

config = YAML::load(File.open('./config.yaml'))

DB = Sequel.connect(config['db'])

DB.create_table :ShortUrls do
	primary_key :id, Integer, :auto_increment
	String      :url
end
	
