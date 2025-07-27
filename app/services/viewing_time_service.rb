class ViewingTimeService
  def self.get_time_watched(user_id, content_id)
    ViewingTime.total_time_watched_for_user_and_content(user_id, content_id)
  end

  def self.track_viewing_time(user_id, content_id, time_watched)
    viewing_time = ViewingTime.new(
      user_id: user_id,
      content_id: content_id,
      time_watched: time_watched,
      viewed_at: Time.current
    )

    if viewing_time.save
      { success: true, viewing_time: viewing_time }
    else
      { success: false, errors: viewing_time.errors.full_messages }
    end
  end

  def self.get_favorite_programs_by_watch_time(user_id)
    # Obtener programas de canal ordenados por tiempo de visualización
    Content.joins(:viewing_times)
           .where(type: 'ChannelProgram')
           .where(viewing_times: { user_id: user_id })
           .group('contents.id')
           .order('SUM(viewing_times.time_watched) DESC')
           .map(&:as_json_for_api)
  end
end
