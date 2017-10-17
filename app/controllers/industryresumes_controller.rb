class IndustryresumesController < ApplicationController
  before_action :set_industryresume, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_client!
  # GET /industryresumes
  # GET /industryresumes.json
  def index
    @industryresumes = Industryresume.all
  end

  # GET /industryresumes/1
  # GET /industryresumes/1.json
  def show
  end

  # GET /industryresumes/new
  def new
    @industryresume = Industryresume.new
  end

  # GET /industryresumes/1/edit
  def edit
  end

  # POST /industryresumes
  # POST /industryresumes.json
  def create
    @industryresume = Industryresume.new(industryresume_params)

    respond_to do |format|
      if @industryresume.save
        format.html { redirect_to @industryresume, notice: 'Industryresume was successfully created.' }
        format.json { render :show, status: :created, location: @industryresume }
      else
        format.html { render :new }
        format.json { render json: @industryresume.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /industryresumes/1
  # PATCH/PUT /industryresumes/1.json
  def update
    respond_to do |format|
      if @industryresume.update(industryresume_params)
        format.html { redirect_to @industryresume, notice: 'Industryresume was successfully updated.' }
        format.json { render :show, status: :ok, location: @industryresume }
      else
        format.html { render :edit }
        format.json { render json: @industryresume.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /industryresumes/1
  # DELETE /industryresumes/1.json
  def destroy
    @industryresume.destroy
    respond_to do |format|
      format.html { redirect_to industryresumes_url, notice: 'Industryresume was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_industryresume
      @industryresume = Industryresume.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def industryresume_params
      params.require(:industryresume).permit(:industry_id, :resume_id)
    end
end
