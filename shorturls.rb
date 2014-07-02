# encoding: UTF-8
# This is a class which handles the creation and getting of short URLs
# from a database.
require 'sequel'
require 'base64'
require 'uri'
# This is the main ShortUrls class, initialized with one argument: the
# Sequel connection string.
class ShortUrls

	# Initialize database connection and create pointer to ShortUrls
	# table.
	def initialize(connection)
		@DB = Sequel.connect(connection)
		@urls = @DB[:ShortUrls]
	end
	# Validate a URL using the uri gem and check to see if it already
	# exists. If it does, it will not be added again; instead, the old
	# short URL will be returned. Returns the short URL in base36
	# string format.
	def put(url)
		# firstly validate the url
		return false unless url =~ /\A#{URI.regexp(['http','https'])}\z/
		# check to see if it already exists in db to prevent dupes
		result = @urls[:url => Base64.encode64(url)]
		return result[:id].to_s(36) if result
		return @urls.insert(:url => Base64.encode64(url)).to_s(36)
	end
	# Get a short URL by base36 ID and return the row from the DB.
	def get(short)
		short_id = short.to_i(36)
		result = @urls[:id => short_id]
		result[:url] = Base64.decode64(result[:url])
		result
	end
end