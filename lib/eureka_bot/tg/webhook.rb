class EurekaBot::Tg::Webhook
  include EurekaBot::Instrumentation

  class TokenVerificationFailed < StandardError;
  end

  attr_reader :params, :resolver_class

  def initialize(params:, resolver_class:)
    @params         = params
    @resolver_class = resolver_class
  end

  def process
    instrument 'eureka-bot.tg.webhook', params: params do
      EurekaBot::Job::Input.perform_later(resolver_class.to_s, params['message'])
    end
  end

  def check_token(valid_token, token_path: [:token])
    token = params.dig(*token_path)
    token.to_s == valid_token.to_s
  end

  def check_token!(valid_token, token_path: [:token])
    check_token(valid_token, token_path: token_path) || (raise TokenVerificationFailed.new({
                                                                                               expected_token: valid_token,
                                                                                               token_path:     token_path,
                                                                                               params:         params
                                                                                           }.to_json))
  end
end
