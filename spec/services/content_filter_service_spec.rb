require 'rails_helper'

RSpec.describe ContentFilterService, type: :service do
  let(:country) { create(:country, :spain) }
  let(:movie) { create(:content, :movie) }
  let(:tv_show) { create(:content, :tv_show) }
  let(:app) { create(:streaming_app, :netflix) }

  before do
    create(:availability, content: movie, streaming_app: app, country: country)
    create(:availability, content: tv_show, streaming_app: app, country: country)
  end

  it 'filters by country code' do
    result = ContentFilterService.get_available_content('es')
    expect(result).to include(movie, tv_show)
  end

  it 'filters by country and type' do
    result = ContentFilterService.get_available_content('es', 'Movie')
    expect(result).to include(movie)
    expect(result).not_to include(tv_show)
  end

  it 'returns empty for invalid country' do
    result = ContentFilterService.get_available_content('xx')
    expect(result).to be_empty
  end
end
