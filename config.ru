require "rubygems"
require "bundler"
Bundler.require

require "./lib/rack_middleware"

run RackMiddlware::Application.new
