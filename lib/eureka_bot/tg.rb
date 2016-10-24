require 'telegram/bot'

module EurekaBot
  module Tg
    extend ActiveSupport::Autoload

    autoload :Version
    autoload :Controller
  end
end
