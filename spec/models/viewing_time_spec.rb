require 'rails_helper'

RSpec.describe ViewingTime, type: :model do
  it { should belong_to(:content) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:time_watched) }
  it { should validate_numericality_of(:time_watched).is_greater_than(0) }
  it { should validate_presence_of(:viewed_at) }

  describe '.total_time_watched_for_user_and_content' do
    let(:content) { create(:content, :channel_program) }
    it 'returns the sum of time_watched for user and content' do
      create(:viewing_time, content: content, user_id: 1, time_watched: 100)
      create(:viewing_time, content: content, user_id: 1, time_watched: 200)
      expect(ViewingTime.total_time_watched_for_user_and_content(1, content.id)).to eq(300)
    end
  end
end
