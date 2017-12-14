class IndexDecorator < ApplicationDecorator

  def initialize
    @industry = Industry.select(:id,:name).all
  end

  def main
    {jobs: Job.select(:id, :title, :location_id, :company_id).includes(:location,:company).last(10).reverse,
     city: Location.select(:id,:suburb).where(suburb:["Sydney", "Melbourne", "Brisbane", "Gold Coast", "Perth", "Adelaide", "Hobart", "Darwin", "Canberra"]),
     category:@industry,
     obj:IndexHelper::JOBS}
  end




end