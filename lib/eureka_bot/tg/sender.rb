class EurekaBot::Tg::Sender
  include EurekaBot::Instrumentation

  attr_reader :logger, :client

  def initialize(client: EurekaBot::Tg.client, logger: EurekaBot.logger)
    @logger = logger
    @client = client
  end

  def deliver(message)
    message = message.stringify_keys
    client.make_request(
        message['method'],
        method: :post,
        payload: message['params'].to_json
    )
  end

end
