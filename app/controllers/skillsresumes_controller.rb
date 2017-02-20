class SkillsresumesController < ApplicationController
  before_action :set_skillsresume, only: [:show, :edit, :update, :destroy]

  # GET /skillsresumes
  # GET /skillsresumes.json
  def index
    @skillsresumes = Skillsresume.all
  end

  # GET /skillsresumes/1
  # GET /skillsresumes/1.json
  def show
  end

  # GET /skillsresumes/new
  def new
    @skillsresume = Skillsresume.new
  end

  # GET /skillsresumes/1/edit
  def edit
  end

  # POST /skillsresumes
  # POST /skillsresumes.json
  def create
    @skillsresume = Skillsresume.new(skillsresume_params)

    respond_to do |format|
      if @skillsresume.save
        format.html { redirect_to @skillsresume, notice: 'Skillsresume was successfully created.' }
        format.json { render :show, status: :created, location: @skillsresume }
      else
        format.html { render :new }
        format.json { render json: @skillsresume.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skillsresumes/1
  # PATCH/PUT /skillsresumes/1.json
  def update
    respond_to do |format|
      if @skillsresume.update(skillsresume_params)
        format.html { redirect_to @skillsresume, notice: 'Skillsresume was successfully updated.' }
        format.json { render :show, status: :ok, location: @skillsresume }
      else
        format.html { render :edit }
        format.json { render json: @skillsresume.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skillsresumes/1
  # DELETE /skillsresumes/1.json
  def destroy
    @skillsresume.destroy
    respond_to do |format|
      format.html { redirect_to skillsresumes_url, notice: 'Skillsresume was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skillsresume
      @skillsresume = Skillsresume.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def skillsresume_params
      params.require(:skillsresume).permit(:name, :level_id, :resume_id)
    end
end
