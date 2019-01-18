class MainSearch
  include Interactor

  def call
    context.sort = context.params.to_h
    @page, @param = context.params[:page], context.params[:main_search]
    if @param[:location_name].blank?
      @param[:location_name] = "Australia"
      @param[:location_id] = ''
    end
    context.param = @param.clone
    @param[:value].delete!("<>{}#@!,.:*&()'`\"’|")
    if @param[:value].blank?
      context.query = ''
      @param[:value] = ''
    else
      context.query = @param[:value]
      @param[:value] = Search.str_to_search(@param[:value])
      @param[:value] = @param[:value].split(" ").map{|t| t=t+":*"}.join("|")
    end
    switch = LazyHash.new('1'=>->{company}, '2'=>->{job}, '3'=>->{resume})
    unless switch[@param[:type]]
      context.fail!
    end

  end

  def sort(type, value)
    if value.present?
      type == "date" ? 'created_at DESC, rank DESC' : 'rank DESC, created_at DESC'
    else
      'created_at DESC'
    end
  end

  def company
    context.objs = Company.includes(:location,:industry).search(@param).order(sort(@param[:sort], @param[:value])).paginate(page: @page, per_page:21).decorate
    context.type = Objects::COMPANIES
    true
  end

  def job
    context.objs = Job.includes(:company,:location).search(@param).order(sort(@param[:sort], @param[:value])).paginate(page: @page, per_page:25).decorate
    context.type = Objects::JOBS
    true
  end

  def resume
    context.objs = Resume.includes(:location, :client).search(@param).order(sort(@param[:sort], @param[:value])).paginate(page: @page, per_page:25).decorate
    context.type = Objects::RESUMES
    true
  end

end

