# Replies example

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
              text:         message.dig('message', 'text'),
              reply_markup: reply_markup(resize_keyboard: true, one_time_keyboard: true) do
                [
                    ['A', 'B', 'C']
                ]
              end.to_json
          }
      )
    end
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