class EurekaBot::Tg::Controller < EurekaBot::Controller
  extend ActiveSupport::Autoload

  autoload :Response
  autoload :SystemController

  def answer(params={})
    super({params: {chat_id: chat_id}}.deep_merge(params))
  end

  def reply(params={})
    answer(params.deep_merge({params: {reply_to_message_id: message_id}}))
  end

  def chat_id
    message.dig('message', 'chat', 'id') || message.dig('callback_query', 'message', 'chat', 'id') || raise("Cant find chat_id in #{message}")
  end

  def message_id
    message.dig('message', 'message_id') || message.dig('callback_query', 'message', 'message_id') || raise("Cant find message_id in #{message}")
  end

  def response_class
    EurekaBot::Tg::Controller::Response
  end

  def client
    EurekaBot::Tg.client
  end
end
