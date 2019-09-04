require 'rails_helper'
describe CreatorsJob::CreateJobClientCompany  do
  it "should rise an error of validation" do
    object = CreatorsJob::CreateJobClientCompany.new
    expect{object.save}.to raise_error(ActiveModel::ValidationError)
  end

  it "should create a new company | client | job" do
    constructor
    object = CreatorsJob::CreateJobClientCompany.new

    expect{order.save}.to raise_error(ActiveModel::ValidationError)
  end

end
