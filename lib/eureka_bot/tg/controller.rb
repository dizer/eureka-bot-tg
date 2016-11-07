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

  def edit(query: {}, edited_message: {}, method: 'editMessageText')
    response << {
        method: method,
        params: query.merge(edited_message)
    }
  end

  def edit_callback(callback, edited_message: {}, method: 'editMessageText')
    query = {
        chat_id:           callback.message.chat.id,
        message_id:        callback.message.message_id,
        inline_message_id: callback.inline_message_id
    }.compact

    edit(query: query, edited_message: edited_message, method: method)
  end
end
