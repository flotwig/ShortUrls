#/usr/bin/env ruby
# encoding: UTF-8

require 'sinatra'
require './shorturls.rb'
require 'yaml'
require 'json'

# cache index.html in memory for speed
index = File.open('index.html').read

get '/' do
	index
end

config = YAML.load_file('config.yaml')
Short = ShortUrls.new(config['db'])

get '/api/new' do
	if config['banned_keywords'].any? { |k| params['url'].include? k }
		JSON.generate('status' => false,
		              'msg'    => "That URL contains banned keywords.")	
	elsif id = Short.put(params['url'])
		JSON.generate('id'     => id,
		              'status' => true)
	else
		JSON.generate('status' => false,
		              'msg'    => "That URL is invalid.")
	end
end

get '/api/get' do
	destination = Short.get( params[ 'id' ] )
	if destination
		JSON.generate('url'    => destination[:url],
		              'status' => true)
	else
		JSON.generate('status' => false)
	end
end

get '/:short' do
	destination = Short.get(params[:short])
	if destination
		redirect destination[:url], 301
	else
		status 404
	end
end
