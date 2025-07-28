require 'rails_helper'

RSpec.describe ChannelProgramSerializer, type: :serializer do
  let(:channel) { create(:content, :channel) }
  let(:channel_program) { create(:content, :channel_program, channel: channel) }
  let(:serializer) { ChannelProgramSerializer.new(channel_program) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  it 'includes the expected attributes' do
    json = JSON.parse(serialization.to_json)
    expect(json['id']).to eq(channel_program.id)
    expect(json['title']).to eq(channel_program.title)
    expect(json['type']).to eq(channel_program.type)
    expect(json['channel_title']).to eq(channel.title)
  end

  it 'does not include viewing_time when no user_id in scope' do
    json = JSON.parse(serialization.to_json)
    expect(json).not_to have_key('viewing_time')
  end

  it 'includes viewing_time when user_id is in scope' do
    user_id = 123
    create(:viewing_time, content: channel_program, user_id: user_id, time_watched: 3600)

    serializer_with_scope = ChannelProgramSerializer.new(channel_program, scope: { user_id: user_id })
    serialization_with_scope = ActiveModelSerializers::Adapter.create(serializer_with_scope)
    json = JSON.parse(serialization_with_scope.to_json)

    expect(json['viewing_time']).to eq(3600)
  end

  it 'returns 0 viewing_time when user has no viewing records' do
    user_id = 999
    serializer_with_scope = ChannelProgramSerializer.new(channel_program, scope: { user_id: user_id })
    serialization_with_scope = ActiveModelSerializers::Adapter.create(serializer_with_scope)
    json = JSON.parse(serialization_with_scope.to_json)

    expect(json['viewing_time']).to eq(0)
  end
end
