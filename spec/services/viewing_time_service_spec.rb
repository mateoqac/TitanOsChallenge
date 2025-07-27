require 'rails_helper'

RSpec.describe ViewingTimeService, type: :service do
  let(:user_id) { 1 }
  let(:program) { create(:content, :channel_program) }

  it 'gets total time watched for user and content' do
    create(:viewing_time, content: program, user_id: user_id, time_watched: 100)
    create(:viewing_time, content: program, user_id: user_id, time_watched: 200)
    expect(ViewingTimeService.get_time_watched(user_id, program.id)).to eq(300)
  end

  it 'tracks viewing time' do
    result = ViewingTimeService.track_viewing_time(user_id, program.id, 150)
    expect(result[:success]).to be true
    expect(result[:viewing_time].time_watched).to eq(150)
  end

  it 'gets favorite programs by watch time' do
    create(:viewing_time, content: program, user_id: user_id, time_watched: 300)
    result = ViewingTimeService.get_favorite_programs_by_watch_time(user_id)
    expect(result.first[:id]).to eq(program.id)
  end
end
