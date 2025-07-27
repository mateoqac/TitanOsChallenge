require 'rails_helper'

RSpec.describe DataImportService, type: :service do
  let(:json_path) { Rails.root.join('public', 'streams_data.json') }

  it 'imports countries and contents from JSON' do
    expect {
      DataImportService.import_from_json(json_path)
    }.to change { Country.count }.by_at_least(1)
  end
end
