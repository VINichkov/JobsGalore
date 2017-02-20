class LanguageresumesController < ApplicationController
  before_action :set_languageresume, only: [:show, :edit, :update, :destroy]

  # GET /languageresumes
  # GET /languageresumes.json
  def index
    @languageresumes = Languageresume.all
  end

  # GET /languageresumes/1
  # GET /languageresumes/1.json
  def show
  end

  # GET /languageresumes/new
  def new
    @languageresume = Languageresume.new
  end

  # GET /languageresumes/1/edit
  def edit
  end

  # POST /languageresumes
  # POST /languageresumes.json
  def create
    @languageresume = Languageresume.new(languageresume_params)

    respond_to do |format|
      if @languageresume.save
        format.html { redirect_to @languageresume, notice: 'Languageresume was successfully created.' }
        format.json { render :show, status: :created, location: @languageresume }
      else
        format.html { render :new }
        format.json { render json: @languageresume.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /languageresumes/1
  # PATCH/PUT /languageresumes/1.json
  def update
    respond_to do |format|
      if @languageresume.update(languageresume_params)
        format.html { redirect_to @languageresume, notice: 'Languageresume was successfully updated.' }
        format.json { render :show, status: :ok, location: @languageresume }
      else
        format.html { render :edit }
        format.json { render json: @languageresume.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /languageresumes/1
  # DELETE /languageresumes/1.json
  def destroy
    @languageresume.destroy
    respond_to do |format|
      format.html { redirect_to languageresumes_url, notice: 'Languageresume was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_languageresume
      @languageresume = Languageresume.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def languageresume_params
      params.require(:languageresume).permit(:resume_id, :language_id, :level_id)
    end
end
