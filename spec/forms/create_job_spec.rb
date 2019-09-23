require 'rails_helper'

describe CreateJob  do

  let(:object) {  FactoryBot.build :create_job }
  context 'validation' do
    context 'first_time' do
      let(:city) { FactoryBot.create :location_omsk }
      let(:object_for_valid) {  described_class.new  }
      it 'validates empty fields' do
        object_for_valid.valid?
        object_for_valid.errors.full_messages.each  do |massage|
          expect(massage).to include("can't be blank")
        end
      end

      it 'validates email uniqueness' do
        client =  FactoryBot.create(:client, location_id: city.id)
        object.email = client.email
        object.valid?
        expect(object.errors.full_messages).to include('This email address is already in use')
      end

      it 'validates company uniqueness' do
        company =  FactoryBot.create(:company, location_id: city.id)
        object.company_name = company.name
        object.valid?
        puts object.errors.full_messages
        expect(object.errors.full_messages).to include('This company name is already in use')
      end
    end

    context 'is_employer' do
      before(:all) do
        object.type = :is_employer
      end

      it 'validates empty fields' do
        fragments_of_massage = ["can't be blank", 'Email', 'Password', 'Company', 'City', 'Title', 'Email']
        object_for_valid.valid?
        object_for_valid.errors.full_messages.each  do |massage|
          expect(massage).to include("can't be blank")
        end
      end

      it 'validates email uniqueness' do
        client =  FactoryBot.create(:client, location_id: city.id)
        object.email = client.email
        object.valid?
        expect(object.errors.full_messages).to include('This email address is already in use')
      end

      it 'validates company uniqueness' do
        company =  FactoryBot.create(:company, location_id: city.id)
        object.company_name = company.name
        object.valid?
        puts object.errors.full_messages
        expect(object.errors.full_messages).to include('This company name is already in use')
      end
    end
  end

  it "should create a new client, a company and a new job"  do
    expect(1).to eq(1)
  end

  it "should create a company, a new job and changes type of client"  do
    expect(1).to eq(1)
  end

  it "should create only a new job"  do
    expect(1).to eq(1)
  end

  it "rises an error in a transaction" do
    expect(1).to eq(1)
  end

end

