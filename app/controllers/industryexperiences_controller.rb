class IndustryexperiencesController < ApplicationController
  before_action :set_industryexperience, only: [:show, :edit, :update, :destroy]

  # GET /industryexperiences
  # GET /industryexperiences.json
  def index
    @industryexperiences = Industryexperience.all
  end

  # GET /industryexperiences/1
  # GET /industryexperiences/1.json
  def show
  end

  # GET /industryexperiences/new
  def new
    @industryexperience = Industryexperience.new
  end

  # GET /industryexperiences/1/edit
  def edit
  end

  # POST /industryexperiences
  # POST /industryexperiences.json
  def create
    @industryexperience = Industryexperience.new(industryexperience_params)

    respond_to do |format|
      if @industryexperience.save
        format.html { redirect_to @industryexperience, notice: 'Industryexperience was successfully created.' }
        format.json { render :show, status: :created, location: @industryexperience }
      else
        format.html { render :new }
        format.json { render json: @industryexperience.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /industryexperiences/1
  # PATCH/PUT /industryexperiences/1.json
  def update
    respond_to do |format|
      if @industryexperience.update(industryexperience_params)
        format.html { redirect_to @industryexperience, notice: 'Industryexperience was successfully updated.' }
        format.json { render :show, status: :ok, location: @industryexperience }
      else
        format.html { render :edit }
        format.json { render json: @industryexperience.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /industryexperiences/1
  # DELETE /industryexperiences/1.json
  def destroy
    @industryexperience.destroy
    respond_to do |format|
      format.html { redirect_to industryexperiences_url, notice: 'Industryexperience was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_industryexperience
      @industryexperience = Industryexperience.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def industryexperience_params
      params.require(:industryexperience).permit(:industry_id, :experience_id)
    end
end
