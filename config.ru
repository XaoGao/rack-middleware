require "rubygems"
require "bundler"
Bundler.require

require "./lib/course"

run Course::Application.new
