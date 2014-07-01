#!/usr/bin/ruby

require 'sinatra'
require './shorturls.rb'
require 'yaml'
require 'json'

get '/' do
	send_file 'index.html'
end

config = YAML::load_file( 'config.yaml' )
Short = ShortUrls.new( config[ 'db' ] )

get '/api/new' do
	id = Short.put( params[ 'url' ] ) 
	if id
		JSON.generate( { 'id'     => id.to_s(36),
		                 'status' => true } )
	else
		JSON.generate( { 'status' => false } )
	end
end

get '/api/get' do
	destination = Short.get( params[ 'id' ] )
	if destination
		JSON.generate( { 'url'    => destination[ :url ],
		                 'status' => true } )
	else
		JSON.generate( { 'status' => false } )
	end
end

get '/:short' do
	destination = Short.get( params[ :short ] )
	if destination
		redirect destination[ :url ], 301
	else
		status 404
	end
end