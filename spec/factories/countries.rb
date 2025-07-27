FactoryBot.define do
  factory :country do
    sequence(:code) { |n| "c#{n}" }
    sequence(:name) { |n| "Country #{n}" }
    active { true }

    trait :inactive do
      active { false }
    end

    trait :spain do
      code { 'es' }
      name { 'Spain' }
    end

    trait :uk do
      code { 'gb' }
      name { 'United Kingdom' }
    end
  end
end
