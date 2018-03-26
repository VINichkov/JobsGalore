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
    context.type = Objects::COMPANIES
    true
  end

  def job
    location=Location.includes(:job).find_by_id(@location)
    context.objs = location.job.order(created_at: :desc).paginate(page: @page, per_page:25).includes(:company,:location).decorate
    context.name =location.name
    context.type = Objects::JOBS
    true
  end

  def resume
    location=Location.includes(:resume).find_by_id(@location)
    context.objs = location.resume.order(updated_at: :desc).paginate(page: @page, per_page:25).includes(:location).decorate
    context.name =location.name
    context.type = Objects::RESUMES
    true
  end
end
