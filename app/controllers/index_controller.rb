class IndexController < ApplicationController
  #caches_page :about
  skip_before_action :verify_authenticity_token
  before_action :category, only: [:main, :by_category]
  def main
    @jobs_last = Job.last(10)
  end

  def advertising_terms_of_use

  end

  def search
    @name={}
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
      else
        redirect_to '/404'
    end
  end

  def category_view
    @name={}
    param = params.permit(:category, :object, :page)
    case param[:object]
      when '1'
        @objs = Industry.includes(:company).find_by_id(param[:category]).company.order(:name).paginate(page: param[:page], per_page:21).includes(:industry,:location)
        @name = {name:'Companies by', industry: Industry.find_by_id(param[:category]).name}
      when '2'
        @objs = Industry.includes(:job).find_by_id(param[:category]).job.order(updated_at: :desc).paginate(page: param[:page], per_page:25).includes(:company,:location)
        @name = {name:'Jobs by', industry: Industry.find_by_id(param[:category]).name}
      when '3'
        @objs = Industry.includes(:resumes).find_by_id(param[:category]).resumes.order(updated_at: :desc).paginate(page: param[:page], per_page:25).includes(:location)
        @name = {name:'Resumes by', industry: Industry.find_by_id(param[:category]).name}
      else
        redirect_to '/404'
    end

  end

  def main_search
    @name={}
    @category = Industry.industries_cashe
    param = main_search_params
    session[:param] = Marshal.load(Marshal.dump(param))
    param[:param][:value] = (param[:param][:value].split(" ").map {|t| t=t+":*"}).join("&")
    case param[:param][:type]
      when '1'
        @objs = Company.includes(:location,:industry).search(param[:param]).order(:name).paginate(page: param[:page], per_page:21)
        @name = {name:'Companies'}
      when '2'
        @objs = Job.includes(:company,:location).search(param[:param]).order(updated_at:  :desc).paginate(page: param[:page], per_page:25)
        @name = {name:'Jobs'}
      when '3'
        @objs = Resume.includes(:location).search(param[:param]).order(updated_at: :desc).paginate(page: param[:page], per_page:25)
        @name = {name:'Resumes'}
      else
        redirect_to '/404'
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

  def send_to_customers
      Email.all.each do |adress|
        puts adress.email
        ContactUsMailer.send_to_customers(adress.email).deliver_later
      end
    redirect_to(root_path, notice: "Show must go on!!!")
  end

  def send_offer

  end

  def terms_and_conditions
  end

  def privacy

  end

  def admin

  end
  private

  def search_params
    params.require(:search).permit(:industry, :object)
  end

  def main_search_params
    {param:params.require(:main_search).permit(:type, :value, :page, :salary, :permanent, :casual, :temp, :contract, :fulltime, :parttime, :flextime, :remote, :options, :category, :location_id, :location_name, :urgent).to_h, page:params.permit(:page).to_h[:page]}
  end

  def category
    #@category=Industry.where('level=?',1)
    @category=Industry.all
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
      else
        render_404
    end
  end


  def query_text(params)
      text = ""
      text = "fts @@ to_tsquery(:query)" unless params[:value].nil?
      text = "and location_id = :location" unless params[:location].nil?
      text = "and location_id = :" unless params[:location].nil?
  end

end
