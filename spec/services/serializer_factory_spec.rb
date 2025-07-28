require 'rails_helper'

RSpec.describe SerializerFactory, type: :service do
  let(:movie) { create(:content, :movie) }
  let(:tv_show) { create(:content, :tv_show) }
  let(:channel_program) { create(:content, :channel_program) }

  describe '.get_serializer_class' do
    it 'returns correct serializer for Movie' do
      expect(SerializerFactory.get_serializer_class('Movie')).to eq(MovieSerializer)
    end

    it 'returns correct serializer for TvShow' do
      expect(SerializerFactory.get_serializer_class('TvShow')).to eq(TvShowSerializer)
    end

    it 'returns correct serializer for ChannelProgram' do
      expect(SerializerFactory.get_serializer_class('ChannelProgram')).to eq(ChannelProgramSerializer)
    end

    it 'returns ContentSerializer for unknown type' do
      expect(SerializerFactory.get_serializer_class('Unknown')).to eq(ContentSerializer)
    end
  end

  describe '.create_serializer' do
    it 'creates correct serializer for Movie' do
      serializer = SerializerFactory.create_serializer(movie)
      expect(serializer).to be_a(MovieSerializer)
    end

    it 'creates correct serializer for TvShow' do
      serializer = SerializerFactory.create_serializer(tv_show)
      expect(serializer).to be_a(TvShowSerializer)
    end

    it 'creates correct serializer for ChannelProgram with scope' do
      scope = { user_id: 123 }
      serializer = SerializerFactory.create_serializer(channel_program, scope)
      expect(serializer).to be_a(ChannelProgramSerializer)
      expect(serializer.instance_variable_get(:@scope)).to eq(scope)
    end
  end
end
