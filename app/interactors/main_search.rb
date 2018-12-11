class MainSearch
  include Interactor

  def call
    context.sort = context.params.to_h
    @page, @param = context.params[:page], context.params[:main_search]
    context.param = @param.clone
    @param[:value].delete!("<>{}#@!,.:*&()'`\"’")
    @param[:value] = @param[:value].gsub(/((\W|^|\s)(on|in|from|i|you|he|she|it|is|are|r|s|we|they|m|who|am|me|whom|her|him|us|them|my|mine|his|hers|your|yours|our|ours|their|theirs|whose|its|that|which|where|why|a|the|as|an|over|under|to|whith|whithout|by|at|into|onto)(\s|$|\W))/,' ')
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

  def sort(type)
    type == "date" ? 'created_at DESC, rank DESC' : 'rank DESC, created_at DESC'
  end

  def company
    context.objs = Company.includes(:location,:industry).search(@param).order(sort(@param[:sort])).paginate(page: @page, per_page:21).decorate
    context.type = Objects::COMPANIES
    true
  end

  def job
    context.objs = Job.includes(:company,:location).search(@param).order(sort(@param[:sort])).paginate(page: @page, per_page:25).decorate
    context.type = Objects::JOBS
    true
  end

  def resume
    context.objs = Resume.includes(:location, :client).search(@param).order(sort(@param[:sort])).paginate(page: @page, per_page:25).decorate
    context.type = Objects::RESUMES
    true
  end

end

