class DataImportService
  def self.import_from_json(file_path)
    data = JSON.parse(File.read(file_path))

    countries = extract_countries_from_data(data)
    countries.each { |country_data| create_or_update_country(country_data) }


    import_contents(data)
  end

  private

  def self.extract_countries_from_data(data)
    countries = Set.new

    data.each_value do |contents|
      contents.each do |content|
        content["availabilities"]&.each do |availability|
          countries.add(availability["market"])
        end

        content["seasons"]&.each do |season|
          season["availabilities"]&.each do |availability|
            countries.add(availability["market"])
          end
        end

        content["channel_programs"]&.each do |program|
          program["availabilities"]&.each do |availability|
            countries.add(availability["market"])
          end
        end
      end
    end

    countries.map { |code| { code: code, name: country_name_from_code(code) } }
  end

  def self.country_name_from_code(code)
    case code
    when "GB" then "United Kingdom"
    when "ES" then "Spain"
    else code.upcase
    end
  end

  def self.create_or_update_country(country_data)
    Country.find_or_create_by(code: country_data[:code]) do |country|
      country.name = country_data[:name]
      country.active = true
    end
  end

  def self.import_contents(data)
    data["movies"]&.each { |movie_data| create_movie(movie_data) }

    data["tv_shows"]&.each { |tv_show_data| create_tv_show(tv_show_data) }

    data["channels"]&.each { |channel_data| create_channel(channel_data) }
  end

  def self.create_movie(movie_data)
    content = Content.create!(
      title: movie_data["original_title"],
      year: movie_data["year"],
      duration_in_seconds: movie_data["duration_in_seconds"],
      type: "Movie"
    )

    create_availabilities(content, movie_data["availabilities"])
  end

  def self.create_tv_show(tv_show_data)
    tv_show = Content.create!(
      title: tv_show_data["original_title"],
      year: tv_show_data["year"],
      duration_in_seconds: tv_show_data["duration_in_seconds"],
      type: "TvShow"
    )

    create_availabilities(tv_show, tv_show_data["availabilities"])

    tv_show_data["seasons"]&.each { |season_data| create_season(season_data, tv_show) }

    tv_show_data["episodes"]&.each { |episode_data| create_episode(episode_data, tv_show) }
  end

  def self.create_season(season_data, tv_show)
    season = Content.create!(
      title: season_data["original_title"],
      year: season_data["year"],
      duration_in_seconds: season_data["duration_in_seconds"],
      type: "Season",
      number: season_data["number"],
      tv_show: tv_show
    )

    create_availabilities(season, season_data["availabilities"])
  end

  def self.create_episode(episode_data, tv_show)
    season = tv_show.seasons.find_by(number: episode_data["season_number"])

    episode = Content.create!(
      title: episode_data["original_title"],
      year: episode_data["year"],
      duration_in_seconds: episode_data["duration_in_seconds"],
      type: "Episode",
      number: episode_data["number"],
      season_number: episode_data["season_number"],
      season: season,
      tv_show: tv_show
    )
  end

  def self.create_channel(channel_data)
    channel = Content.create!(
      title: channel_data["original_title"],
      year: channel_data["year"],
      duration_in_seconds: channel_data["duration_in_seconds"],
      type: "Channel"
    )

    create_availabilities(channel, channel_data["availabilities"])

    channel_data["channel_programs"]&.each { |program_data| create_channel_program(program_data, channel) }
  end

  def self.create_channel_program(program_data, channel)
    program = Content.create!(
      title: program_data["original_title"],
      year: program_data["year"],
      duration_in_seconds: program_data["duration_in_seconds"],
      type: "ChannelProgram",
      channel: channel
    )

    create_availabilities(program, program_data["availabilities"])
    create_schedules(program, program_data["schedule"])
  end

  def self.create_availabilities(content, availabilities_data)
    availabilities_data&.each do |availability_data|
      app = StreamingApp.find_or_create_by(name: availability_data["app"])
      country = Country.find_by(code: availability_data["market"])

      Availability.create!(
        content: content,
        streaming_app: app,
        country: country,
        stream_info: availability_data["stream_info"]
      )
    end
  end

  def self.create_schedules(content, schedules_data)
    schedules_data&.each do |schedule_data|
      Schedule.create!(
        content: content,
        start_time: schedule_data["start_time"],
        end_time: schedule_data["end_time"]
      )
    end
  end
end
