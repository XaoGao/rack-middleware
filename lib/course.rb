require "debug"
require "logger"
require "dry-configurable"

require_relative "./course/statuses"
require_relative "./course/application"
require_relative "./course/middleware/assets"
require_relative "./course/middleware/exceptions"
require_relative "./course/middleware/unsuccess"
require_relative "./course/middleware/logger"

module Course
  extend Dry::Configurable

  setting :root, default: File.join(File.dirname(__FILE__), "..")

  setting :logger, default: Logger.new($stdout)
end
