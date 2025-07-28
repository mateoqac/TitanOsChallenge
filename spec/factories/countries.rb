FactoryBot.define do
  factory :country do
    sequence(:code) { |n| "C#{n}" }
    sequence(:name) { |n| "Country #{n}" }
    active { true }

    trait :inactive do
      active { false }
    end

    trait :spain do
      code { 'ES' }
      name { 'Spain' }
    end

    trait :uk do
      code { 'GB' }
      name { 'United Kingdom' }
    end
  end
end
