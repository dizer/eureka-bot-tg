# Echo server

require_relative '_setup'

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

# EurekaBot::Job.queue_adapter = :async # default
EurekaBot::Job.queue_adapter = :inline # everything will work synchronously. Not recommended.

offset = nil
loop do
  EurekaBot::Tg.client.make_request('getUpdates', payload: {offset: offset}.compact.to_json).each do |update|
    EurekaBot::Job::Input.perform_later(SampleResolver.to_s, update)
    offset = offset ? [offset, update['update_id'] + 1].max : update['update_id'] + 1
  end
  EurekaBot.logger.info '#ping'
end