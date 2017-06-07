class CompaniesController < ApplicationController
  load_and_authorize_resource :company, only:[:edit, :update, :destroy]
  authorize_resource only:[ :settings_company, :edit_logo]
  before_action :set_company, only: [:show, :edit, :update, :destroy]
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
  #def index
  #  @companies = Company.all
  #end

  # GET /companies/1
  # GET /companies/1.json
  #def show
  #end

  # GET /companies/new
  #def new
   # @company = Company.new
  #end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  #def create
  #  @company = Company.new(company_params)

  #  respond_to do |format|
  #    if @company.save
  #      format.html { redirect_to @company, notice: 'Company was successfully created.' }
  #      format.json { render :show, status: :created, location: @company }
  #    else
   #     format.html { render :new }
  #      format.json { render json: @company.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

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
    if (@company.industry.first.nil? and not industry.empty?) or (not industry.empty? and not (@company.industry.first.id == industry))
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
