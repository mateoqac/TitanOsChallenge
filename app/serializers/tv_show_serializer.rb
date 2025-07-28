class TvShowSerializer < ContentSerializer
  has_many :seasons, serializer: SeasonSerializer
  has_many :episodes, serializer: EpisodeSerializer
end
