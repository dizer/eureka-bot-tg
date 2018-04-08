class FilesBot::Controller < EurekaBot::Tg::Controller
  extend ActiveSupport::Autoload

  autoload :CommandsController
  autoload :DocumentsController
  autoload :TextController
end