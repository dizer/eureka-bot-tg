FactoryGirl.define do
  factory :telegram_update, class: Hash do
    sequence(:update_id)
    association :message, factory: :telegram_message, strategy: :build
    initialize_with { attributes.as_json }
  end
end
