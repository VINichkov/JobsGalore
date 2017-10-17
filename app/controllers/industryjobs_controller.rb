class IndustryjobsController < ApplicationController
  before_action :set_industryjob, only: [:show, :edit, :update, :destroy]
  # GET /industryjobs
  # GET /industryjobs.json
  def index
    @industryjobs = Industryjob.all
  end

  # GET /industryjobs/1
  # GET /industryjobs/1.json
  def show
  end

  # GET /industryjobs/new
  def new
    @industryjob = Industryjob.new
  end

  # GET /industryjobs/1/edit
  def edit
  end

  # POST /industryjobs
  # POST /industryjobs.json
  def create
    @industryjob = Industryjob.new(industryjob_params)

    respond_to do |format|
      if @industryjob.save
        format.html { redirect_to @industryjob, notice: 'Industryjob was successfully created.' }
        format.json { render :show, status: :created, location: @industryjob }
      else
        format.html { render :new }
        format.json { render json: @industryjob.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /industryjobs/1
  # PATCH/PUT /industryjobs/1.json
  def update
    respond_to do |format|
      if @industryjob.update(industryjob_params)
        format.html { redirect_to @industryjob, notice: 'Industryjob was successfully updated.' }
        format.json { render :show, status: :ok, location: @industryjob }
      else
        format.html { render :edit }
        format.json { render json: @industryjob.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /industryjobs/1
  # DELETE /industryjobs/1.json
  def destroy
    @industryjob.destroy
    respond_to do |format|
      format.html { redirect_to industryjobs_url, notice: 'Industryjob was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_industryjob
      @industryjob = Industryjob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def industryjob_params
      params.require(:industryjob).permit(:industry_id, :job_id)
    end
end
