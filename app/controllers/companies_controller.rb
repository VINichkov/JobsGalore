require 'company/company_wizard'
require 'company/company_admin'
class CompaniesController < ApplicationController

  include Wizard
  include Admin
  before_action :admin!, only: [:admin_show,
                                :admin_edit,
                                :admin_update,
                                :admin_destroy,
                                :admin_edit_logo,
                                :admin_destroy_member,
                                :admin_show_member_of_team,
                                :show_member_of_team,
                                :admin_update_member,
                                :admin_edit_member,
                                :admin_index_job,
                                :admin_new_job]
  load_and_authorize_resource :company, only:[:show,
                                              :edit,
                                              :update,
                                              :destroy,
                                              :team]

  before_action :set_member, only: [:admin_destroy_member,
                                    :admin_show_member_of_team,
                                    :show_member_of_team,
                                    :admin_update_member,
                                    :admin_edit_member,
                                    :admin_index_job]
  before_action :set_jobs, only: [ :admin_new_job]
  before_action :set_company, only: [:show,
                                     :edit,
                                     :update,
                                     :destroy,
                                     :admin_show,
                                     :admin_edit,
                                     :admin_update,
                                     :admin_destroy,
                                     :admin_edit_logo]
  before_action :current_company, only:[:settings_company, :edit_logo]
  before_action :authenticate_client!, only:[:settings_company,
                                             :edit_logo,
                                             :edit,
                                             :update,
                                             :destroy]

  #company


  def settings_company
  end

  def edit_logo
  end

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all.includes(:location,:industry, :size, :client).order(:name).paginate(page: params[:page], per_page:21)
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def company_jobs
    @objs = Job.where(company_id: params[:id]).includes(:location).order(updated_at: :desc).paginate(page: params[:page], per_page:25).decorate
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to settings_company_path, notice: 'Company was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find_by(id:params[:id]).decorate
    end

    def set_client
      @client = Client.find_by(id:params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :size_id, :location_id, :site, :logo, :recrutmentagency, :description, :realy, :industry_id)
    end

    def job_params
      params.require(:job).permit(:title, :location_id, :salarymin, :salarymax, :permanent, :casual, :temp, :contract, :fulltime, :parttime, :flextime, :remote, :description, :company_id, :education_id, :client_id, :career, :industry_id, :close,:page)
    end

    def set_jobs
      @client,  @company = params[:id].split('x')
    end

    def set_member
      a = params[:id].split('x')
      @client = Client.find(a[0])
      @company =a[1]
    end
end
