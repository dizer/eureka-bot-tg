require 'telegram/bot'

module EurekaBot
  module Tg
    extend ActiveSupport::Autoload

    autoload :Version
    autoload :Controller
    autoload :Utils
  end
end
