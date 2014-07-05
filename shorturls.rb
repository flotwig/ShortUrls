# encoding: UTF-8
# This is a class which handles the creation and getting of short URLs
# from a database.
require 'sequel'
require 'base64'
require 'uri'
# This is the main ShortUrls class.
class ShortUrls
	# Initialize database connection and create pointer to ShortUrls
	# table.
	# @param connection [String] A Sequel connection string.
	def initialize(connection)
		@DB = Sequel.connect(connection)
		@urls = @DB[:ShortUrls]
	end
	# Validate a URL using the uri gem and check to see if it already
	# exists. If it does, it will not be added again; instead, the old
	# short URL will be returned. Returns the short URL in base36
	# string format.
	# @param url [String] A URL to be shortened.
	# @return [Boolean] False if URL is invalid.
	# @return [String] The ID of the string in base 36 (a-z0-9, like 0a or 3a4zfq
	def put(url)
		# firstly validate the url
		return false unless url =~ /\A#{URI.regexp(['http','https'])}\z/
		# check to see if it already exists in db to prevent dupes
		result = @urls[:url => Base64.encode64(url)]
		return result[:id].to_s(36) if result
		return @urls.insert(:url => Base64.encode64(url)).to_s(36)
	end
	# Get a short URL by base36 ID and return the row from the DB.
	# @param short [String] A base36 ID (a-z0-9, like 0a or 3a4zfq)
	# @return [Hash] The row from the database. { :id, :url }
	def get(short)
		short_id = short.to_i(36)
		result = @urls[:id => short_id]
		result[:url] = Base64.decode64(result[:url])
		result
	end
end
