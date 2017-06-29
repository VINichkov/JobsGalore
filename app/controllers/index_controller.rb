class IndexController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :category, only: [:main, :by_category]
  def main
    @jobs_last = nil
    @jobs_last = Job.last(10)
  end

  def advertising_terms_of_use

  end

  def search
    param = params.permit(:category, :object, :page)
    case param[:object]
      when '1'
        @objs = Industry.find_by_id(param[:category]).company.order(:name).paginate(page: param[:page], per_page:21)
        @name = {name:'Companies by', industry: Industry.find_by_id(param[:category]).name}
      when '2'
        @objs = Industry.find_by_id(param[:category]).job.order(updated_at: :desc).paginate(page: param[:page], per_page:25)
        @name = {name:'Jobs by', industry: Industry.find_by_id(param[:category]).name}
      when '3'
        @objs = Industry.find_by_id(param[:category]).resumes.order(updated_at: :desc).paginate(page: param[:page], per_page:25)
        @name = {name:'Resumes by', industry: Industry.find_by_id(param[:category]).name}
    end
  end

  def category_view

    param = params.permit(:category, :object, :page)
    case param[:object]
      when '1'
        @objs = Industry.find_by_id(param[:category]).company.order(:name).paginate(page: param[:page], per_page:21)
        @name = {name:'Companies by', industry: Industry.find_by_id(param[:category]).name}
      when '2'
        @objs = Industry.find_by_id(param[:category]).job.order(updated_at: :desc).paginate(page: param[:page], per_page:25)
        @name = {name:'Jobs by', industry: Industry.find_by_id(param[:category]).name}
      when '3'
        @objs = Industry.find_by_id(param[:category]).resumes.order(updated_at: :desc).paginate(page: param[:page], per_page:25)
        @name = {name:'Resumes by', industry: Industry.find_by_id(param[:category]).name}
    end

  end

  def main_search
    @category = Industry.all
    param = main_search_params
    session[:param] = Marshal.load(Marshal.dump(param))
    param[:param][:value] = (param[:param][:value].split(" ").map {|t| t=t+":*"}).join("&")
    case param[:param][:type]
      when '1'
        @objs = Company.search(param[:param]).order(:name).paginate(page: param[:page], per_page:21)
        @name = {name:'Companies'}
      when '2'
        @objs = Job.search(param[:param]).order(updated_at:  :desc).paginate(page: param[:page], per_page:25)
        @name = {name:'Jobs'}
      when '3'
        @objs = Resume.search(param[:param]).order(updated_at: :desc).paginate(page: param[:page], per_page:25)
        @name = {name:'Resumes'}
    end
  end

  def by_category
  end

  def about
  end

  def contact
  end

  def send_mail
    ContactUsMailer.send_mail(params.require(:contact).permit(:firstname, :lastname, :email, :subject, :message, :phone).to_h).deliver_later
    redirect_to(contact_path, notice: 'Email sent')
  end

  def terms_and_conditions

  end

  def privacy

  end

  private

  def search_params
    params.require(:search).permit(:industry, :object)
  end

  def main_search_params
    {param:params.require(:main_search).permit(:type, :value, :page, :salary, :permanent, :casual, :temp, :contract, :fulltime, :parttime, :flextime, :remote, :options, :category, :location_id, :location_name).to_h, page:params.permit(:page).to_h[:page]}
  end

  def category
    @category=Industry.where('level=?',1)
    if params[:obj].nil?
      params[:obj]='2'
    end
    case params[:obj]
      when '1'
        @objs = {code:1, name:"Companies"}
      when '2'
        @objs = {code:2, name:"Jobs"}
      when '3'
        @objs = {code:3, name:"Resumes"}
    end
  end


  def query_text(params)
      text = ""
      text = "fts @@ to_tsquery(:query)" unless params[:value].nil?
      text = "and location_id = :location" unless params[:location].nil?
      text = "and location_id = :" unless params[:location].nil?

  end

end
