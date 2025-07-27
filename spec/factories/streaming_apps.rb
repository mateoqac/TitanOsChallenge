FactoryBot.define do
  factory :streaming_app do
    sequence(:name) { |n| "App #{n}" }

    trait :netflix do
      name { 'Netflix' }
    end

    trait :prime_video do
      name { 'Prime Video' }
    end

    trait :amagi do
      name { 'Amagi' }
    end
  end
end
