FactoryGirl.define do
  # factory :telegram_message, class: Hash do
  factory :telegram_message, class: Telegram::Bot::Types::Message do
    sequence(:message_id)

    from ({
        id:         1,
        first_name: 'John',
        last_name:  'Doe',
        username:   'john_doe'
    })

    sequence(:date, 1.day.ago.to_i)

    chat ({
        id:         1,
        type:       'private',
        title:      nil,
        username:   'john_doe',
        first_name: 'John',
        last_name:  'Doe'
    })

    trait :start do
      text '/start'
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

    trait :with_sticker do
      sticker (
                  {
                      'file_id'   => 'BQADAgADTwQAAiaoBAABQz5e8qCNIiYC',
                      'width'     => 512,
                      'height'    => 512,
                      'thumb'     => {
                          'file_id'   => 'AAQCABMMroIqAAQ3sDZFx0jn_XEYAAIC',
                          'width'     => 128,
                          'height'    => 128,
                          'file_size' => 5542
                      },
                      'emoji'     => '-',
                      'file_size' => 37024
                  }
              )
    end

    # initialize_with { attributes.as_json }
  end
end
