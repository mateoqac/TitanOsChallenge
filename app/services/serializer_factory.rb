class SerializerFactory
  SERIALIZER_MAPPING = {
    'Movie' => MovieSerializer,
    'TvShow' => TvShowSerializer,
    'Season' => SeasonSerializer,
    'Episode' => EpisodeSerializer,
    'Channel' => ChannelSerializer,
    'ChannelProgram' => ChannelProgramSerializer
  }.freeze

  def self.get_serializer_class(content_type)
    SERIALIZER_MAPPING[content_type] || ContentSerializer
  end

  def self.create_serializer(content, scope = {})
    serializer_class = get_serializer_class(content.type)
    serializer_class.new(content, scope: scope)
  end
end
