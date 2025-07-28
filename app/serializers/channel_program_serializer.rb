class ChannelProgramSerializer < ContentSerializer
  attributes :channel_title, :schedules

  has_many :schedules, serializer: ScheduleSerializer

  def channel_title
    object.channel&.title
  end

  def viewing_time
    user_id = scope&.dig(:user_id)
    return nil unless user_id

    ViewingTimeService.get_time_watched(user_id, object.id)
  end

  def attributes(*args)
    hash = super
    user_id = scope&.dig(:user_id)
    hash[:viewing_time] = viewing_time if user_id
    hash
  end
end
