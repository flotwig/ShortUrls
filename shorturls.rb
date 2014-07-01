require 'sequel'
require 'base64'
require 'uri'

class ShortUrls
	def initialize( connection )
		@DB = Sequel.connect( connection )
		@urls = @DB[ :ShortUrls ]
	end
	def put( url )
		# firstly validate the url
		unless url =~ /\A#{URI::regexp(['http', 'https'])}\z/
			return false
		end
		# check to see if it already exists in db to prevent dupes
		result = @urls[ :url => Base64.encode64( url ) ]
		if result
			return result[ :id ]
		else # create new record
			return @urls.insert( :url => Base64.encode64( url ) )
		end
	end
	def get( short )
		short_id = short.to_i(36)
		result = @urls[ :id => short_id ]
		result[ :url ] = Base64.decode64( result[ :url ] )
		result
	end
end