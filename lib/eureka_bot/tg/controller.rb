class EurekaBot::Tg::Controller < EurekaBot::Controller
  extend ActiveSupport::Autoload

  autoload :Response

  def answer(params={})
    super({params: {chat_id: chat.try(:id)}}.deep_merge(params))
  end

  def chat
    case message
      when Telegram::Bot::Types::Message
        message.chat
      when Telegram::Bot::Types::CallbackQuery
        message.message.chat
    end
  end

  def response_class
    EurekaBot::Tg::Controller::Response
  end

  def tg_client
    @tg_client ||= Telegram::Bot::Client.new(tg_token, logger: logger, timeout: 3)
  end

  def tg_token
    'Example'
  end
end
