require "rubygems"
require "bundler"
Bundler.require

require "./lib/course"

# Handle the request to public pages
use Course::Middleware::ExceptionsMiddleware
use Course::Middleware::PublicMiddlware

run Course::Application.new
