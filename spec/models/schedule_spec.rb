require 'rails_helper'

RSpec.describe Schedule, type: :model do
  it { should belong_to(:content) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:end_time) }

  it 'is invalid if end_time is before start_time' do
    schedule = build(:schedule, start_time: 2.hours.from_now, end_time: 1.hour.from_now)
    expect(schedule).not_to be_valid
    expect(schedule.errors[:end_time]).to be_present
  end
end
