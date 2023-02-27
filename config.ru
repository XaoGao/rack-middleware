require "rubygems"
require "bundler"
Bundler.require

require "./lib/rack_middleware"

run RackMiddleware::Application.new
