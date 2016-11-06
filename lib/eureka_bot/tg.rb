require 'telegram/bot'

module EurekaBot
  module Tg
    extend ActiveSupport::Autoload

    autoload :Controller
    autoload :Utils
    autoload :Version
    autoload :Webhook
  end
end
