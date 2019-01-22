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
    context.objs = Company.where(location_id: @location).order(:name).paginate(page: @page, per_page:21).includes(:industry,:location).decorate
    location=context.objs.first.location
    context.name = location.name
    context.query = {type: Objects::COMPANIES.code, value:"", location_id:location.id, location_name:location.name, open:false}
    context.suburb = location.suburb
    context.type = Objects::COMPANIES
    context.key = "Jobs Galore, Australia, Job, Jobs, Galore, Jobsgalore, Australian Companies, #{location.name}, Companies in #{location.suburb}, comnany in #{location.suburb}, career #{location.suburb},#{location.suburb} employment, Jobs in #{location.suburb}, #{location.suburb} job, #{location.suburb} employment, careers in #{location.suburb}, in #{location.suburb}"
    true
  end

  def job
    context.objs = Job.where(location_id: @location).order(created_at: :desc).paginate(page: @page, per_page:25).includes(:company, :location).decorate
    location=context.objs.first.location
    context.name = location.name
    context.query = {type: Objects::JOBS.code, value:"", location_id:location.id, location_name:location.name, open:false}
    context.suburb = location.suburb
    context.type = Objects::JOBS
    context.key = "Jobs Galore, Australia, Job, Jobs, Galore, Jobsgalore, #{location.name}, Jobs in #{location.suburb}, career #{location.suburb}, #{location.suburb} employment, Work in #{location.suburb}, #{location.suburb} job, #{location.suburb} jobs, #{location.suburb} employment opportunities, careers in #{location.suburb}, in #{location.suburb}, job in #{location.suburb}"
    true
  end

  def resume
    context.objs = Resume.where(location_id: @location).order(created_at: :desc).paginate(page: @page, per_page:25).includes(:location, :client).decorate
    location=context.objs.first.location
    context.name = location.name
    context.query = {type: Objects::RESUMES.code, value:"", location_id:location.id, location_name:location.name, open:false}
    context.suburb = location.suburb
    context.type = Objects::RESUMES
    context.key = "CV, resume online, recrutment, Jobs Galore, Australia, Job, Jobs, Galore, Jobsgalore, #{location.name}, Resumes in #{location.suburb}, Talents in #{location.suburb}, #{location.suburb} career, #{location.suburb} employment, #{location.suburb} talent, #{location.suburb} job, #{location.suburb} employment, careers in #{location.suburb}, in #{location.suburb}"
    true
  end
end
