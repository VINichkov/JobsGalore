class ResumesController < ApplicationController
  before_action :set_resume, only: [ :show, :edit, :update, :destroy, :admin_show, :admin_edit, :admin_update, :admin_destroy]
  before_action :authenticate_client!, only:[:log_in,:new, :edit, :create, :update, :destroy]
  load_and_authorize_resource :resume, only:[:edit, :update, :destroy, :admin_index, :admin_new,:admin_show,:admin_edit,:admin_create,:admin_update,:admin_destroy, :admin_extras]
  authorize_resource only:[:new, :create]

  # GET /resumes
  # GET /resumes.json
  def index
    @resumes = Resume.all
  end

  def log_in
    respond_to do |format|
        format.html { redirect_to resume_path(params[:id])}
    end
  end
  # GET /resumes/1
  # GET /resumes/1.json
  def show
  end

  # GET /resumes/new
  def new
    unless current_client.resp
      @resume = Resume.new
    else
      redirect_to root_path, alert: "Please register as an applicant"
    end

  end

  # GET /resumes/1/edit
  def edit
  end

  # POST /resumes
  # POST /resumes.json
  def create
    param = resume_params
    industry = param[:industry]
    experience=param[:experience]
    param.delete(:industry)
    param.delete(:experience)
    param.delete(:location_name)
    param[:client] = current_client
    @resume = Resume.new(param)
    if experience
      experience.each do |exp, exp1|
        if not(exp1[:position].empty?)
          @resume.experience.new(employer:exp1[:employer], location_id:exp1[:location_id], site:exp1[:site], titlejob:exp1[:position], datestart:exp1[:datestart], dateend:exp1[:dateend], description:exp1[:description] )
        end
      end
    end
    @resume.industryresume.new(industry:Industry.find_by_id(industry.to_i))
    respond_to do |format|
      if @resume.save
        format.html { redirect_to client_root_path, notice: 'Resume was successfully created.' }
        format.json { render :show, status: :created, location: @resume }
      else
        format.html { render :new }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resumes/1
  # PATCH/PUT /resumes/1.json
  def update
    param = resume_params
    if param[:location_id].nil? or param[:location_id].empty?
      param[:location_id]=find_location(param[:location_name])
    end
    industry = param[:industry]
    experience=param[:experience]
    param.delete(:industry)
    param.delete(:experience)
    param.delete(:location_name)
    param[:client] = current_client
    @resume.experience.destroy_all
    if experience
      experience.each do |exp, exp1|
        if not(exp1[:position].empty?)
            if exp1[:location_id].nil? or exp1[:location_id].empty?
              exp1[:location_id]=find_location(exp1[:location_name])
            end
            @resume.experience.new(employer:exp1[:employer], location_id:exp1[:location_id], site:exp1[:site], titlejob:exp1[:position], datestart:exp1[:datestart], dateend:exp1[:dateend], description:exp1[:description] )
          end
      end
    end
    @resume.industryresume.destroy_all
    @resume.industryresume.new(industry:Industry.find_by_id(industry))
    respond_to do |format|
      if @resume.update(param)
        format.html { redirect_to client_root_path, notice: 'Resume was successfully updated.' }
        format.json { render :show, status: :ok, location: @resume }
        ResumesMailer.add_resume(current_client.email).deliver_later
      else
        format.html { render :edit }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resumes/1
  # DELETE /resumes/1.json
  def destroy
    @resume.destroy
    respond_to do |format|
      format.html { redirect_to client_root_path, notice: 'Resume was successfully destroyed.' }
    end
  end

  def admin_index
    @resumes = Resume.all.includes(:location,:client).order(:desiredjobtitle).paginate(page: params[:page], per_page:21)
  end

  # GET /resumes/1
  # GET /resumes/1.json
  def admin_show
  end

  # GET /resumes/new
  def admin_new
      @resume = Resume.new
      @resume.location_id = 9509
  end

  # GET /resumes/1/edit
  def admin_edit
  end

  # POST /resumes
  # POST /resumes.json
  def admin_create
    param = resume_params
    industry = param[:industry]
    experience=param[:experience]
    param.delete(:industry)
    param.delete(:experience)
    param.delete(:location_name)
    @resume = Resume.new(param)
    if experience
      experience.each do |exp, exp1|
        if not(exp1[:position].empty?)
          @resume.experience.new(employer:exp1[:employer], location_id:exp1[:location_id], site:exp1[:site], titlejob:exp1[:position], datestart:exp1[:datestart], dateend:exp1[:dateend], description:exp1[:description] )
        end
      end
    end
    @resume.industryresume.new(industry:Industry.find_by_id(industry.to_i))
    respond_to do |format|
      if @resume.save
        format.html { redirect_to admin_resumes_show_path(@resume), notice: 'Resume was successfully created.' }
        format.json { render :admin_show, status: :created, location: @resume }
      else
        format.html { render :admin_new }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resumes/1
  # PATCH/PUT /resumes/1.json
  def admin_update
    param = resume_params
    if param[:location_id].nil? or param[:location_id].empty?
      param[:location_id]=find_location(param[:location_name])
    end
    industry = param[:industry]
    experience=param[:experience]
    param.delete(:industry)
    param.delete(:experience)
    param.delete(:location_name)
    @resume.experience.destroy_all
    if experience
      experience.each do |exp, exp1|
        if not(exp1[:position].empty?)
          if exp1[:location_id].nil? or exp1[:location_id].empty?
            exp1[:location_id]=find_location(exp1[:location_name])
          end
          @resume.experience.new(employer:exp1[:employer], location_id:exp1[:location_id], site:exp1[:site], titlejob:exp1[:position], datestart:exp1[:datestart], dateend:exp1[:dateend], description:exp1[:description] )
        end
      end
    end
    @resume.industryresume.destroy_all
    @resume.industryresume.new(industry:Industry.find_by_id(industry))
    respond_to do |format|
      if @resume.update(param)
        format.html { redirect_to admin_resumes_show_path(@resume), notice: 'Resume was successfully updated.' }
        format.json { render :admin_show, status: :ok, location: @resume }
      else
        format.html { render :admin_edit }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resumes/1
  # DELETE /resumes/1.json
  def admin_destroy
    @resume.destroy
    respond_to do |format|
      format.html { redirect_to admin_resumes_url, notice: 'Resume was successfully destroyed.' }
    end
  end

  def admin_extras
    param = params.require(:resumes).permit(:id, :option)
    resume = Resume.find_by_id(param[:id])
    case param[:option]
      when '1'
        if not resume.urgent.nil?
          resume.urgent_off
        else
          resume.urgent_on
        end
      when '2'
        if not resume.top.nil?
          resume.top_off
        else
          resume.top_on
        end
      when '3'
        if not resume.highlight.nil?
          resume.highlight_off
        else
          resume.highlight_on
        end
    end
    respond_to do |format|
      format.html { redirect_to admin_resumes_show_path(resume),  notice: 'Resume was successfully destroyed.' }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resume
      @resume = Resume.find(params[:id])
      @experience = @resume.experience.order(datestart: :desc).map do | res|
        {id:res.id,
         titlejob:res.titlejob,
         employer:res.employer,
         location_id:res.location ? res.location.id : "",
         location_name:res.location ? "#{res.location.suburb}, #{res.location.state}" : "",
         site:res.site,
         datestart:res.datestart ? res.datestart.strftime("%d %B %Y") : "",
         dateend: res.dateend ? res.dateend.strftime("%d %B %Y") : "",
         description:res.description}
      end
    end

    def find_location(name)
      loc = Location.search(name).limit(1)
      if loc.nil? or loc.empty?
        ""
      else
        loc.first.id
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resume_params
      params.require(:resume).permit(:desiredjobtitle,
                                     :salary,
                                     :permanent,
                                     :casual,
                                     :temp,
                                     :page,
                                     :contract,
                                     :fulltime,
                                     :parttime,
                                     :flextime,
                                     :remote,
                                     :abouteme,
                                     :client_id,
                                     :industry,
                                     :location_id,
                                     :location_name,
                                     :experience=>{:bloc_0=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_1=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_2=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_3=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_4=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_5=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_6=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_7=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_8=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_9=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_10=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_11=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_12=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_13=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description],
                                                 :bloc_14=>[:datestart, :dateend, :employer, :location_name, :location_id, :site, :position, :description]})
         end
end
