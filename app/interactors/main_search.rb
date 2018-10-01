class MainSearch
  include Interactor

  def call
    @page, @param = context.params[:page], context.params[:main_search]
    @param[:value].delete!("<>{}#@!,.:*&()'`\"’")
    if @param[:value].blank?
      @param[:value] = ''
      context.query = ''
    else
      context.query = @param[:value].split(" ")
      @param[:value] = @param[:value].split(" ").map{|t| t=t+":*"}.join("|")
    end
    switch = LazyHash.new('1'=>->{company}, '2'=>->{job}, '3'=>->{resume})
    unless switch[@param[:type]]
      context.fail!
    end

  end

  def company
    context.objs = Company.includes(:location,:industry).search(@param).order('rank DESC, created_at DESC').paginate(page: @page, per_page:21).decorate
    context.type = Objects::COMPANIES
    true
  end

  def job
    context.objs = Job.includes(:company,:location).search(@param).order('rank DESC, created_at DESC').paginate(page: @page, per_page:25).decorate
    context.type = Objects::JOBS
    true
  end

  def resume
    context.objs = Resume.includes(:location, :client).search(@param).order('rank DESC, created_at DESC').paginate(page: @page, per_page:25).decorate
    context.type = Objects::RESUMES
    true
  end

end

