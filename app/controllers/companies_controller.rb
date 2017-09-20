class CompaniesController < ApplicationController
  load_and_authorize_resource :company, only:[:edit, :update, :destroy, :admin_index, :admin_edit_logo,:admin_new,:admin_show,:admin_edit,:admin_create,:admin_update,:admin_destroy ]
  authorize_resource only:[ :settings_company, :edit_logo]
  before_action :set_company, only: [:show, :edit, :update, :destroy, :admin_show, :admin_edit, :admin_update, :admin_destroy, :admin_edit_logo]
  before_action :authenticate_client!, only:[:settings_company,
                                             :edit_logo,
                                             :edit,
                                             :update,
                                             :destroy]

  def settings_company
    @company = current_client.company.first
  end

  def edit_logo
    @company = current_client.company.first
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
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def company_jobs

    @objs = Company.find_by_id(params[:id]).job.order(updated_at: :desc).paginate(page: params[:page], per_page:25)
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    param = company_params
    industry = param[:industry]
    puts industry
    param.delete(:industry)
    if (@company.industry.first.nil? and not industry.nil?) or (not industry.nil? and not (@company.industry.first.id == industry))
      @company.industrycompany.destroy_all
      @company.industrycompany.create(industry_id: industry)
    end
    respond_to do |format|
      if @company.update(param)
        format.html { redirect_to settings_company_path, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def admin_edit_logo
  end

  # GET /companies
  # GET /companies.json
  def admin_index
    @companies = Company.all.includes(:location,:industry, :size, :client).order(:name).paginate(page: params[:page], per_page:21)
  end

  # GET /companies/1
  # GET /companies/1.json
  def admin_show
  end

  # GET /companies/new
  def admin_new
    @company = Company.new
  end

  # GET /companies/1/edit
  def admin_edit
  end

  # POST /companies
  # POST /companies.json
  def admin_create
    @company = Company.new(company_params)
    respond_to do |format|
      if @company.save
        format.html { redirect_to admin_company_show_path(@company), notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :admin_new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def admin_company_jobs
    @objs = Company.find_by_id(params[:id]).job.order(updated_at: :desc).paginate(page: params[:page], per_page:25)
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def admin_update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to admin_company_show_path(@company), notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :admin_edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def admin_destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to admin_company_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :size_id, :location_id, :site, :logo, :recrutmentagency, :description, :realy, :industry)
    end
end
