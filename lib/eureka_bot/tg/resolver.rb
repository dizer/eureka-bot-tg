class EurekaBot::Tg::Resolver < EurekaBot::Resolver
  def resolve

    if callback_query.present?
      version, controller, action, *data = callback_query['data'].split(':')
      return {
          controller: controller,
          action:     action.to_sym,
          params:     {raw: data, version: version}
      }
    end

    if simple_message.present?
      if simple_message['text'].to_s[0] == '/'
        parts = simple_message['text'].split(' ')
        return {
            controller: 'commands',
            action:     parts[0].gsub('/', '').to_sym,
            params:     {raw: parts[1..-1], version: 'v1'}
        }
      end

      if simple_message['photo'].present?
        return {
            controller: 'photos',
            action:     :photo,
            params:     {photos: simple_message['photo'], version: 'v1'}
        }
      end

      if simple_message['document'].present?
        return {
            controller: 'documents',
            action:     :document,
            params:     {document: simple_message['document'], version: 'v1'}
        }
      end

      if simple_message['text'].present?
        return {
            controller: 'text',
            action:     :text,
            params:     {raw: simple_message['text'], version: 'v1'}
        }
      end
    end

    {
        controller: 'system',
        action:     :nothing
    }
  end

  def controller_namespace
    EurekaBot::Tg::Controller
  end

  def simple_message
    message['message'].presence
  end

  def callback_query
    message['callback_query'].presence
  end
end
