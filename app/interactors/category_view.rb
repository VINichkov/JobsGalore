class CategoryView
  include Interactor

  def call
    @page, @category = context.params[:page], context.params[:category]
    switch = LazyHash.new('1'=>->{company}, '2'=>->{job}, '3'=>->{resume})
    unless switch[context.params[:object]]
      context.fail!
    end
  end

  def company
    category = Industry.includes(:company).find_by_id(@category)
    context.objs = category.company.order(:name).paginate(page: @page, per_page:21).includes(:industry,:location).decorate
    context.type = Objects::COMPANIES
    context.name = {name:'Companies by', industry: category.name}
    true
  end

  def job
    category = Industry.includes(:job).find_by_id(@category)
    context.objs = category.job.order(created_at: :desc).paginate(page: @page, per_page:25).includes(:company,:location).decorate
    context.type = Objects::JOBS
    context.name = {name:'Jobs by', industry: category.name}
    true
  end

  def resume
    category = Industry.includes(:resume).find_by_id(@category)
    context.objs = category.resume.order(updated_at: :desc).paginate(page: @page, per_page:25).includes(:location).decorate
    context.type = Objects::RESUMES
    context.name = {name:'Resumes by', industry: category.name}
    true
  end
end
