class MainSearch
  include Interactor

  def call
    page, param = context.params[:page], context.params[:main_search]
    param[:value].delete!("!:*&()'`\"’")
    param[:value].blank? ? param[:value] = '' : param[:value] = param[:value].split(" ").map{|t| t=t+":*"}.join("&")
    case param[:type]
      when '1'
        context.objs = Company.includes(:location,:industry).search(param).order(:name).paginate(page: page, per_page:21)
        context.name = {name:'Companies'}
      when '2'
        context.objs = Job.includes(:company,:location).search(param).paginate(page: page, per_page:25).order(created_at:  :desc).decorate
        context.name = {name:'Jobs'}
      when '3'
        context.objs = Resume.includes(:location).search(param).order(updated_at: :desc).paginate(page: page, per_page:25)
        context.name = {name:'Resumes'}
      else
        context.fail!
    end
  end

end

