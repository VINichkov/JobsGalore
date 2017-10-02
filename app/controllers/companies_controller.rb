class CompaniesController < ApplicationController
  load_and_authorize_resource :company, only:[:edit, :update, :destroy, :admin_index, :admin_edit_logo,:admin_new,:admin_show,:admin_edit,:admin_create,:admin_update,:admin_destroy ]
  authorize_resource only:[ :settings_company, :edit_logo]
  before_action :set_company, only: [:show, :edit, :update, :destroy, :admin_show, :admin_edit, :admin_update, :admin_destroy, :admin_edit_logo]
  before_action :authenticate_client!, only:[:settings_company,
                                             :edit_logo,
                                             :edit,
                                             :update,
                                             :destroy]
  before_action :set_member, only: [:admin_destroy_member, :destroy_member, :admin_show_member_of_team, :show_member_of_team, :admin_update_member, :admin_edit_member]
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

  def client_in_company_index
    @id = params[:id]
    @clients = Company.find(@id).client.all.includes(:location).order(:firstname).paginate(page: params[:page], per_page:21)
  end

  def adimin_edit_job

  end
  def admin_new_job

  end
  def admin_show_job

  end
  def admin_destroy_job
  end

  def admin_new_member
    @client = Client.new
    @company = params[:id]
  end

  def admin_create_member
    @client = Client.new(client_params)
    @id = params.require(:id).permit(:id).to_h
    puts @id[:id]
    respond_to do |format|
      if @client.save
        Responsible.create(client_id:@client.id, company_id:@id[:id])
        format.html { redirect_to admin_company_team_path(@id[:id]), notice: 'Client was successfully created.' }
      else
        format.html { redirect_to admin_team_new_path(@id[:id]) }
      end
    end
  end

  def admin_edit_member
  end

  def admin_update_member
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to admin_company_team_path(@company), notice: 'Done!' }
      else
        format.html { redirect_to admin_team_edit("#{@client.id}x#{@company}") }
      end
    end
  end



  def admin_destroy_member
    @client.destroy
    respond_to do |format|
      format.html { redirect_to admin_company_team_path(@company), notice: 'Done!' }
    end
  end

  def admin_show_member_of_team
  end
  def new_member

  end
  def destroy_member

  end
  def show_member_of_team

  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    def set_member
      a = params[:id].split('x')
      @client = Client.find(a[0])
      @company =a[1]
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :size_id, :location_id, :site, :logo, :recrutmentagency, :description, :realy, :industry)
    end

    def client_params
      params.require(:client).permit(:firstname, :lastname, :email, :phone, :password, :character, :photo, :gender, :location_id, :company_id, :birth, :page)
    end
end
