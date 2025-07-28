class EpisodeSerializer < ContentSerializer
  attributes :number, :season_number, :season_title, :tv_show_title

  def season_title
    object.season&.title
  end

  def tv_show_title
    object.tv_show&.title
  end
end
