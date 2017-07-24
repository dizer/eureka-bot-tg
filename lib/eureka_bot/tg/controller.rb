class EurekaBot::Tg::Controller < EurekaBot::Controller
  extend ActiveSupport::Autoload

  autoload :Response
  autoload :SystemController

  def answer(params={})
    super({params: {chat_id: chat_id}}.deep_merge(params))
  end

  def chat_id
    message.dig('chat', 'id')
  end

  def response_class
    EurekaBot::Tg::Controller::Response
  end

  def client
    EurekaBot::Tg.client
  end
end
