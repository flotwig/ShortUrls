require './shorturls.rb'
require 'yaml'

config = YAML.load_file( 'config.yaml' )

Short = ShortUrls.new( config[ 'db' ] )

newid = Short.put('http://google.com')

print newid
print newid.to_s(36)

print Short.get(newid.to_s(36))
