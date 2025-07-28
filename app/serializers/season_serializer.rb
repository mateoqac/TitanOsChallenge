class SeasonSerializer < ContentSerializer
  attributes :number, :tv_show_title

  has_many :episodes, serializer: EpisodeSerializer

  def tv_show_title
    object.tv_show&.title
  end
end
