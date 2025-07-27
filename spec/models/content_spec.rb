require 'rails_helper'

RSpec.describe Content, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:type) }
  it { should have_many(:availabilities).dependent(:destroy) }
  it { should have_many(:streaming_apps).through(:availabilities) }
  it { should have_many(:countries).through(:availabilities) }
  it { should have_many(:schedules).dependent(:destroy) }
  it { should have_many(:viewing_times).dependent(:destroy) }
  it { should have_many(:user_favorites) }

  it { should belong_to(:tv_show).class_name('Content').optional }
  it { should belong_to(:season).class_name('Content').optional }
  it { should belong_to(:channel).class_name('Content').optional }

  it { should have_many(:seasons).class_name('Content') }
  it { should have_many(:episodes).class_name('Content') }
  it { should have_many(:channel_programs).class_name('Content') }

  describe '#as_json_for_api' do
    let(:content) { create(:content, :movie) }
    it 'returns a hash with expected keys' do
      json = content.as_json_for_api
      expect(json).to include(:id, :title, :type, :availabilities)
    end
  end
end
