FactoryBot.define do
  factory :content do
    sequence(:title) { |n| "Content #{n}" }
    year { 2020 }
    duration_in_seconds { 3600 }
    type { 'Movie' }

    trait :movie do
      type { 'Movie' }
      title { 'Test Movie' }
      year { 2020 }
      duration_in_seconds { 7200 }
    end

    trait :tv_show do
      type { 'TvShow' }
      title { 'Test TV Show' }
      year { 2019 }
      duration_in_seconds { nil }
    end

    trait :season do
      type { 'Season' }
      title { 'Season 1' }
      year { 2019 }
      duration_in_seconds { nil }
      number { 1 }
    end

    trait :episode do
      type { 'Episode' }
      title { 'Episode 1' }
      year { 2019 }
      duration_in_seconds { 3600 }
      number { 1 }
      season_number { 1 }
    end

    trait :channel do
      type { 'Channel' }
      title { 'Test Channel' }
      year { nil }
      duration_in_seconds { nil }
    end

    trait :channel_program do
      type { 'ChannelProgram' }
      title { 'Test Program' }
      year { nil }
      duration_in_seconds { nil }
    end
  end
end
