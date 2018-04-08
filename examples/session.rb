# Session example (Redis)

require_relative '_setup'
require 'redis'

$redis = Redis.new(url: 'redis://localhost:6379/1')

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
              text: session.data[:text],
          }
      )

      session.update(text: message.dig('message', 'text'))
    end
  end

  def session
    @session ||= EurekaBot::Session.new(['session', chat['id'], from['id']].join('.'), redis: $redis)
  end
end

offset = nil
loop do
  EurekaBot::Tg.client.make_request('getUpdates', payload: {offset: offset}.compact.to_json).each do |update|
    EurekaBot::Job::Input.perform_later(SampleResolver.to_s, update)
    offset = offset ? [offset, update['update_id'] + 1].max : update['update_id'] + 1
  end
  EurekaBot.logger.info '#ping'
end