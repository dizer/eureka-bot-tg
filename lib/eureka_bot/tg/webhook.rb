class EurekaBot::Tg::Webhook
  class TokenVerificationFailed < StandardError;
  end

  attr_reader :params, :resolver_class

  def initialize(params:, resolver_class:)
    @params         = params
    @resolver_class = resolver_class
  end

  def process
    update  = Telegram::Bot::Types::Update.new(params)
    message = update.inline_query ||
        update.chosen_inline_result ||
        update.callback_query ||
        update.edited_message ||
        update.message
    EurekaBot::Job.perform_async(resolver_class, message)
  end

  def check_token(valid_token, token_path: [:token])
    token = params.dig(*token_path)
    token.to_s == valid_token.to_s
  end

  def check_token!(valid_token, token_path: [:token])
    check_token(valid_token, token_path: token_path) || (raise TokenVerificationFailed.new)
  end
end
