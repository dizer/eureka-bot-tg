namespace :eureka do
  namespace :tg do
    desc 'Telegram long polling'
    task :listen do
      token          = ENV.fetch('TG_TOKEN')
      resolver_class = ENV.fetch('RESOLVER').constantize
      offset         = ENV.fetch('OFFSET', nil)
      limit          = ENV.fetch('LIMIT', 100)
      timeout        = ENV.fetch('TIMEOUT', 10)

      EurekaBot::Tg.client = EurekaBot::Tg::Client.new(token: token)

      EurekaBot.logger.info 'starting getting #getUpdates'

      loop do
        EurekaBot::Tg.client.make_request('getUpdates', payload: {offset: offset, limit: limit, timeout: timeout}.compact.to_json).each do |update|
          EurekaBot::Job::Input.perform_later(resolver_class.to_s, update)
          offset = offset ? [offset, update['update_id'] + 1].max : update['update_id'] + 1
        end
        EurekaBot.logger.info '#ping'
      end
    end

    desc 'Get/Set webhook'
    task :webhook do
      token           = ENV.fetch('TG_TOKEN')
      url             = ENV.fetch('URL', nil)
      max_connections = ENV.fetch('max_connections', nil)
      client          = EurekaBot::Tg::Client.new(token: token)

      if url.present?
        EurekaBot.logger.info(
            {
                result: client.make_request(
                    'setWebhook',
                    payload: {
                                 url:             url,
                                 max_connections: max_connections
                             }.compact.to_json
                )
            }.to_json
        )
      end

      EurekaBot.logger.info client.make_request('getWebhookInfo').to_json
    end
  end
end

