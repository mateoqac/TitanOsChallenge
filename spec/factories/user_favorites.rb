FactoryBot.define do
  factory :user_favorite do
    user_id { 1 }
    association :favoritable, factory: :streaming_app
    position { 1 }

    trait :for_content do
      association :favoritable, factory: [ :content, :channel_program ]
    end
  end
end
