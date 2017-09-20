class IndustrycompaniesController < ApplicationController
  load_and_authorize_resource :industrycompany , only:[:index, :new, :show,:edit,:create,:update,:destroy ]
  before_action :set_industrycompany, only: [:show, :edit, :update, :destroy]
  authorize_resource
  # GET /industrycompanies
  # GET /industrycompanies.json
  def index
    @industrycompanies = Industrycompany.all.includes(:company,:industry).paginate(page: params[:page], per_page:21)
  end

  # GET /industrycompanies/1
  # GET /industrycompanies/1.json
  def show
  end

  # GET /industrycompanies/new
  def new
    @industrycompany = Industrycompany.new
  end

  # GET /industrycompanies/1/edit
  def edit
  end

  # POST /industrycompanies
  # POST /industrycompanies.json
  def create
    @industrycompany = Industrycompany.new(industrycompany_params)

    respond_to do |format|
      if @industrycompany.save
        format.html { redirect_to industrycompanies_url, notice: 'Industrycompany was successfully created.' }
        format.json { render :show, status: :created, location: @industrycompany }
      else
        format.html { render :new }
        format.json { render json: @industrycompany.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /industrycompanies/1
  # PATCH/PUT /industrycompanies/1.json
  def update
    respond_to do |format|
      if @industrycompany.update(industrycompany_params)
        format.html { redirect_to industrycompanies_url, notice: 'Industrycompany was successfully updated.' }
        format.json { render :show, status: :ok, location: @industrycompany }
      else
        format.html { render :edit }
        format.json { render json: @industrycompany.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /industrycompanies/1
  # DELETE /industrycompanies/1.json
  def destroy
    @industrycompany.destroy
    respond_to do |format|
      format.html { redirect_to industrycompanies_url, notice: 'Industrycompany was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_industrycompany
      @industrycompany = Industrycompany.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def industrycompany_params
      params.require(:industrycompany).permit(:industry_id, :company_id)
    end
end
