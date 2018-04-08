require_relative '../_setup'
require_relative 'files_bot'

offset = nil
loop do
  EurekaBot::Tg.client.make_request('getUpdates', payload: {offset: offset}.compact.to_json).each do |update|
    EurekaBot::Job::Input.perform_later(FilesBot::Resolver.to_s, update)
    offset = offset ? [offset, update['update_id'] + 1].max : update['update_id'] + 1
  end
  EurekaBot.logger.info '#ping'
end