require "rubygems"
require "bundler"
Bundler.require

require "./lib/course"

use Course::Middleware::Logger, logger: Course.config.logger
use Course::Middleware::Assets
use Course::Middleware::Unsuccess
use Course::Middleware::Exceptions

run Course::Application.new
