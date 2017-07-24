FactoryGirl.define do
  factory :telegram_message, class: Hash do
    sequence(:message_id)

    from ({
        id:         1,
        first_name: 'John',
        last_name:  'Doe',
        username:   'john_doe'
    })

    chat ({
        id:         1,
        first_name: 'John',
        last_name:  'Doe',
        username:   'john_doe',
        type:       'private',
    })

    sequence(:date, Time.parse('2016-01-01 12:00 Z').to_i)

    text 'hello'

    trait :start do
      text '/start'
      entities [
                   {
                       type:   'bot_command',
                       offset: 0,
                       length: 6
                   }
               ]
    end

    trait :at_group do
      chat ({
          id:         -1,
          type:       'group',
          title:      'Example group',
          username:   nil,
          first_name: nil,
          last_name:  nil
      })
    end

    trait :callback do
      data 'callback-data'
    end

    initialize_with {attributes.compact.as_json}
  end
end
