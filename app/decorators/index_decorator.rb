class IndexDecorator < ApplicationDecorator


  def self.main
    rezult = by_category
    {jobs: Job.select(:id, :title, :location_id, :company_id, :updated_at).includes(:location,:company).last(10).reverse,
     city: Location.major,
     category:rezult[:category],
     obj:rezult[:obj]}
  end

  def self.by_category(arg = {})
    rezult = {category:Industry.all}
    case true
      when arg[:type] == '1'
        rezult[:obj] = IndexHelper::COMPANIES
      when ((arg[:type]=='2') or (arg[:type].nil?))
        rezult[:obj] = IndexHelper::JOBS
      when arg[:type]=='3'
        rezult[:obj] = IndexHelper::RESUMES
      else
        raise ArgumentError, "No parameters"
    end
    rezult
  end


end