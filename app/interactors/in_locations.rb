class InLocations
  include Interactor

  def call
    @page, @location = context.params[:page], context.params[:location]
    switch = LazyHash.new('1'=>->{company}, '2'=>->{job}, '3'=>->{resume})
    unless switch[context.params[:object]]
      context.fail!
    end
  end

  def company
    location=Location.includes(:company).find_by_id(@location)
    context.objs = location.company.order(:name).paginate(page: @page, per_page:21).includes(:industry,:location).decorate
    context.name =location.name
    context.suburb = location.suburb
    context.type = Objects::COMPANIES
    context.key = "Jobs Galore, Australia, Job, Jobs, Galore, Jobsgalore, Australian Companies, #{location.name}, Companies in #{location.suburb}, comnany in #{location.suburb}, career #{location.suburb},#{location.suburb} employment, Jobs in #{location.suburb}, #{location.suburb} job, #{location.suburb} employment, careers in #{location.suburb}, in #{location.suburb}"
    true
  end

  def job
    location=Location.includes(:job).find_by_id(@location)
    context.objs = location.job.order(created_at: :desc).paginate(page: @page, per_page:25).includes(:company,:location).decorate
    context.name =location.name
    context.suburb = location.suburb
    context.type = Objects::JOBS
    context.key = "Jobs Galore, Australia, Job, Jobs, Galore, Jobsgalore, #{location.name}, Jobs in #{location.suburb}, career #{location.suburb}, #{location.suburb} employment, Work in #{location.suburb}, #{location.suburb} job, #{location.suburb} jobs, #{location.suburb} employment opportunities, careers in #{location.suburb}, in #{location.suburb}, job in #{location.suburb}"
    true
  end

  def resume
    location=Location.includes(:resume).find_by_id(@location)
    context.objs = location.resume.order(updated_at: :desc).paginate(page: @page, per_page:25).includes(:location).decorate
    context.name =location.name
    context.suburb = location.suburb
    context.type = Objects::RESUMES
    context.key = "CV, resume online, recrutment, Jobs Galore, Australia, Job, Jobs, Galore, Jobsgalore, #{location.name}, Resumes in #{location.suburb}, Talents in #{location.suburb}, #{location.suburb} career, #{location.suburb} employment, #{location.suburb} talent, #{location.suburb} job, #{location.suburb} employment, careers in #{location.suburb}, in #{location.suburb}"
    true
  end
end
