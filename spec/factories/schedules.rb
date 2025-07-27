FactoryBot.define do
  factory :schedule do
    association :content
    start_time { 1.hour.ago }
    end_time { 1.hour.from_now }
  end
end
