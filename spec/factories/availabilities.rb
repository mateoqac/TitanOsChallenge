FactoryBot.define do
  factory :availability do
    association :content
    association :streaming_app
    association :country

    trait :with_stream_info do
      stream_info { { url: 'https://example.com/stream' } }
    end
  end
end
