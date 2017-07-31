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

  def chat
    message.dig('message', 'chat') || message.dig('callback_query', 'message', 'chat') || raise("Cant find chat in #{message}")
  end

  def from
    message.dig('message', 'from') || message.dig('callback_query', 'message', 'from') || raise("Cant find from in #{message}")
  end

  def chat_id
    chat['id']
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
