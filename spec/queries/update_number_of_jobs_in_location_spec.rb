require 'rails_helper'

describe UpdateNumberOfJobsInLocation do
  let(:amount){ 5 }
  before(:each) do
    location = FactoryBot.create(:location_omsk)
    client = FactoryBot.create(:client, location_id: location.id)
    company = FactoryBot.create(:company, location_id: location.id)
    amount.times do
      FactoryBot.create(:job,
        client_id: client.id,
        company_id: company.id,
        location_id: client.location_id
      )
    end
  end

  it 'call sql query' do
    described_class.new.call
    expect(Location.first.counts_jobs).to eq(5)
  end
end
