#!/usr/bin/env ruby

require 'sinatra'
require 'slim'
require 'slim/include'

set :bind, '0.0.0.0'
set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
	slim :index
end
