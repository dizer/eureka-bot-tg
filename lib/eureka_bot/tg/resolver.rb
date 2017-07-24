class EurekaBot::Tg::Resolver < EurekaBot::Resolver
  def resolve
    if message['text'].to_s[0] == '/'
      parts = message['text'].split(' ')
      return {
          controller: 'commands',
          action:     parts[0].gsub('/', '').to_sym,
          params:     {raw: parts[1..-1], version: 'v1'}
      }
    end

    if message['photo'].present?
      return {
          controller: 'photos',
          action:     :photo,
          params:     {photos: message['photo'], version: 'v1'}
      }
    end

    if message['text'].present?
      return {
          controller: 'text',
          action:     :text,
          params:     {raw: message['text'], version: 'v1'}
      }
    end

    {
        controller: 'system',
        action:     :nothing
    }
  end

  def controller_namespace
    EurekaBot::Tg::Controller
  end
end
