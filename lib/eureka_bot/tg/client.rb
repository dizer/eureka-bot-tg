require 'rest-client'

class EurekaBot::Tg::Client
  include EurekaBot::Instrumentation

  attr_reader :token, :url

  def initialize(token:, url: 'https://api.telegram.org')
    @url   = url
    @token = token
  end

  def get_file_url(file_id)
    file_path = make_request('getFile', payload: {file_id: file_id}.to_json)['file_path']
    [url, '/file', '/bot', token, '/', file_path].join
  end

  def parse_response(response)
    ActiveSupport::JSON.decode(response) if response.present?
  end

  def extract_result(response)
    if response['ok']
      response['result']
    else
      raise EurekaBot::Tg::Client::Error.new(error_code: response['error_code'], description: response['description'])
    end
  end

  def make_request(route, method: :get, **rest)
    full_route = Array.wrap(route).join('/')
    instrument 'eureka-bot.tg.request', route: full_route, method: method, rest: rest do
      res = resource[full_route]

      options = rest.clone
      payload = options.delete(:payload)
      headers = (res.options[:headers] || {}).merge(options)

      request           = {
          method:  method,
          url:     res.url,
          headers: headers
      }

      request[:payload] = payload if payload

      response = nil

      begin
        response = parse_response(
            RestClient::Request.execute(request).body
        )
      rescue RestClient::Exception => e
        EurekaBot.exception_handler(e, e.class, custom_params: {error: e, http_code: e.http_code, http_body: e.http_body}.to_json)
        response = parse_response(e.http_body)
      end

      if response
        instrument 'eureka-bot.tg.response', response: response
        extract_result(response)
      end
    end
  end

  def resource
    @resource ||= RestClient::Resource.new(
        [
            url,
            ['bot', token].join
        ].to_param,
        headers: {
            'Content-Type' => 'application/JSON'
        },
        logger:  EurekaBot.logger,
        timeout: 30
    )
  end

  class Error < StandardError
    attr_reader :error_code, :description

    def initialize(error_code:, description: '')
      @error_code  = error_code
      @description = description
    end

    def to_s
      to_json
    end

    def to_json
      {error_code: error_code, description: description}.to_json
    end

  end

end
