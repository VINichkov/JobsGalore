class SkillsjobsController < ApplicationController
  before_action :set_skillsjob, only: [:show, :edit, :update, :destroy]

  # GET /skillsjobs
  # GET /skillsjobs.json
  def index
    @skillsjobs = Skillsjob.all
  end

  # GET /skillsjobs/1
  # GET /skillsjobs/1.json
  def show
  end

  # GET /skillsjobs/new
  def new
    @skillsjob = Skillsjob.new
  end

  # GET /skillsjobs/1/edit
  def edit
  end

  # POST /skillsjobs
  # POST /skillsjobs.json
  def create
    @skillsjob = Skillsjob.new(skillsjob_params)

    respond_to do |format|
      if @skillsjob.save
        format.html { redirect_to @skillsjob, notice: 'Skillsjob was successfully created.' }
        format.json { render :show, status: :created, location: @skillsjob }
      else
        format.html { render :new }
        format.json { render json: @skillsjob.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skillsjobs/1
  # PATCH/PUT /skillsjobs/1.json
  def update
    respond_to do |format|
      if @skillsjob.update(skillsjob_params)
        format.html { redirect_to @skillsjob, notice: 'Skillsjob was successfully updated.' }
        format.json { render :show, status: :ok, location: @skillsjob }
      else
        format.html { render :edit }
        format.json { render json: @skillsjob.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skillsjobs/1
  # DELETE /skillsjobs/1.json
  def destroy
    @skillsjob.destroy
    respond_to do |format|
      format.html { redirect_to skillsjobs_url, notice: 'Skillsjob was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skillsjob
      @skillsjob = Skillsjob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def skillsjob_params
      params.require(:skillsjob).permit(:name, :level_id, :job_id)
    end
end
