require "debug"

require_relative "./course/application"
require_relative "./course/middleware/assets_middleware"
require_relative "./course/middleware/exceptions_middleware"
require_relative "./course/middleware/unsuccess_middleware"
require_relative "./course/middleware/logger_middleware"

module Course; end
