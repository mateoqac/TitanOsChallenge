require 'rails_helper'

RSpec.describe SearchService, type: :service do
  let(:country) { create(:country, :spain) }
  let(:app) { create(:streaming_app, :netflix) }
  let(:movie) { create(:content, :movie, title: 'Star Wars', year: 1980) }

  before do
    create(:availability, content: movie, streaming_app: app, country: country)
  end

  it 'searches by title' do
    result = SearchService.global_search('star', 'es')
    expect(result[:contents].map { |c| c[:title] || c['title'] }).to include('Star Wars')
  end

  it 'searches by year' do
    result = SearchService.global_search('1980', 'es')
    expect(result[:contents].map { |c| c[:year] || c['year'] }).to include(1980)
  end

  it 'searches by app name' do
    result = SearchService.global_search('netflix', 'es')
    expect(result[:streaming_apps].map { |a| a[:name] || a['name'] }).to include('Netflix')
  end

  it 'returns empty for no matches' do
    result = SearchService.global_search('nope', 'es')
    expect(result[:contents]).to be_empty
    expect(result[:streaming_apps]).to be_empty
  end
end
