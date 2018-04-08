$:.unshift File.dirname(__FILE__)

class FilesBot
  extend ActiveSupport::Autoload

  autoload :Resolver
  autoload :Controller
end

error_logger = Logger.new(STDERR)
EurekaBot.add_exception_handler do |e, klass, args|
  error_logger.error(e)
end