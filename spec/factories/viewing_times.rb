FactoryBot.define do
  factory :viewing_time do
    association :content
    user_id { 1 }
    time_watched { 3600 }
    viewed_at { Time.current }
  end
end
