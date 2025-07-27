class Content < ApplicationRecord
  # Deshabilitar STI ya que no estamos usando herencia real
  self.inheritance_column = nil

  has_many :availabilities, dependent: :destroy
  has_many :streaming_apps, through: :availabilities
  has_many :countries, through: :availabilities
  has_many :schedules, dependent: :destroy
  has_many :viewing_times, dependent: :destroy
  has_many :user_favorites, as: :favoritable, dependent: :destroy

  # STI relationships
  belongs_to :tv_show, class_name: 'Content', optional: true
  belongs_to :season, class_name: 'Content', optional: true
  belongs_to :channel, class_name: 'Content', optional: true

  has_many :seasons, class_name: 'Content', foreign_key: 'tv_show_id'
  has_many :episodes, class_name: 'Content', foreign_key: 'season_id'
  has_many :channel_programs, class_name: 'Content', foreign_key: 'channel_id'

  validates :title, presence: true
  validates :type, presence: true

  scope :by_type, ->(content_type) { where(type: content_type) }
  scope :by_country, ->(country_code) { joins(:availabilities).joins(:countries).where(countries: { code: country_code }) }

  def as_json_for_api
    case type
    when 'Movie'
      as_json_for_movie
    when 'TvShow'
      as_json_for_tv_show
    when 'Season'
      as_json_for_season
    when 'Episode'
      as_json_for_episode
    when 'Channel'
      as_json_for_channel
    when 'ChannelProgram'
      as_json_for_channel_program
    else
      as_json_for_base
    end
  end

  def as_json_for_channel_program(user_id = nil, viewing_time = nil)
    base_json = as_json_for_base
    base_json.merge!({
      channel_title: channel&.title,
      schedules: schedules.map(&:as_json)
    })

    # Solo incluir viewing_time si se proporciona
    base_json.merge!({ viewing_time: viewing_time }) if viewing_time.present? || user_id.present?

    base_json
  end

  private

  def as_json_for_base
    {
      id: id,
      title: title,
      year: year,
      duration_in_seconds: duration_in_seconds,
      type: type,
      availabilities: availabilities.map(&:as_json)
    }
  end

  def as_json_for_movie
    as_json_for_base
  end

  def as_json_for_tv_show
    base_json = as_json_for_base
    base_json.merge!({
      seasons: seasons.map(&:as_json_for_season),
      episodes: episodes.map(&:as_json_for_episode)
    })
  end

  def as_json_for_season
    base_json = as_json_for_base
    base_json.merge!({
      number: number,
      tv_show_title: tv_show&.title,
      episodes: episodes.map(&:as_json_for_episode)
    })
  end

  def as_json_for_episode
    base_json = as_json_for_base
    base_json.merge!({
      number: number,
      season_number: season_number,
      season_title: season&.title,
      tv_show_title: tv_show&.title
    })
  end

  def as_json_for_channel
    base_json = as_json_for_base
    base_json.merge!({
      channel_programs: channel_programs.map(&:as_json_for_channel_program)
    })
  end
end
