require "rubygems"
require "bundler"
Bundler.require

require "./lib/course"

use Course::Middleware::LoggerMiddleware
use Course::Middleware::ExceptionsMiddleware
use Course::Middleware::AssetsMiddleware
use Course::Middleware::UnsuccessMiddleware

run Course::Application.new
