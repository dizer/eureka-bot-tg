# Sample sinatra server

require_relative '_setup'

require 'sinatra'

class SampleResolver < EurekaBot::Tg::Resolver
  def controller_namespace
    Controllers
  end
end

class Controllers < EurekaBot::Tg::Controller
  class TextController < Controllers
    def text
      answer(
          method: 'sendMessage',
          params: {
              text: message.dig('message', 'text'),
          }
      )
    end
  end
end

class SampleServer < Sinatra::Base
  configure do
    EurekaBot::Tg.client = EurekaBot::Tg::Client.new(token: $tg_token)

    enable :logging
    use Rack::CommonLogger, EurekaBot.logger
  end

  helpers do
    def webhook
      @webhook ||= EurekaBot::Tg::Webhook.new(
          params:         params,
          resolver_class: SampleResolver
      )
    end
  end

  post '/webhook' do
    webhook.check_token!('S0M∑-S∑CUR∑-T0K∑N')
    webhook.process

    [
        200,
        {'Content-Type' => 'text/plain'},
        ''
    ]
  end

end
