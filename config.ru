require "rubygems"
require "bundler"
Bundler.require

require "./lib/course"

use Course::Middleware::Logger, logger: Course.config.logger
use Course::Middleware::Etag
use Course::Middleware::Assets, path_to_assets: Course.config.assets_path
use Course::Middleware::Unsuccess
use Course::Middleware::Exceptions

run Course::Application.new
