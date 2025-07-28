class ChannelSerializer < ContentSerializer
  has_many :channel_programs, serializer: ChannelProgramSerializer
end
