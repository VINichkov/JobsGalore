class JobsController < ApplicationController
  before_action :authenticate_client!, only:[:new, :edit, :create, :update, :destroy]
  load_and_authorize_resource :job
  before_action :set_job, only: [:show, :edit, :update, :destroy, :admin_show, :admin_edit, :admin_update, :admin_destroy]
  before_action :employer!, only: :new


  # GET /jobs
  # GET /jobs.json
  #def index
  #  @jobs = Job.all
  #end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
      @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  # POST /jobs.json
  def create
    param = job_params
    industry = param[:ind]
    param.delete(:ind)
    @job = Job.new(param)
    @job.industryjob.new(industry:Industry.find_by_id(industry.to_i))
    @job.company_id = current_client.company.first.id
    @job.client_id = current_client.id
    respond_to do |format|
      if @job.save
        if @job.client.send_email
          @JobsMailer.add_job({mail:current_client.email, firstname:current_client.firstname, id:@job.id, title:@job.title}).deliver_later
        end
        format.html { redirect_to client_root_path, notice: 'Job was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    param = job_params
    industry = param[:ind]
    param.delete(:ind)
    @job.industryjob.destroy_all
    @job.industryjob.new(industry:Industry.find_by_id(industry))
    respond_to do |format|
      if @job.update(param)
        format.html { redirect_to client_root_path, notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to client_root_path, notice: 'Job was successfully destroyed.' }
    end
  end

  def admin_index
    @not_id = Industryjob.select(:job_id).all.to_a
    puts @not_id
    @jobs = Job.where("id not in ?",@not_id).includes(:location,:company, :client).order(:close).paginate(page: params[:page], per_page:21)
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def admin_show
  end

  # GET /jobs/new
  def admin_new
      @job = Job.new
      @job.location_id = 9509
  end

  # GET /jobs/1/edit
  def admin_edit
  end

  # POST /jobs
  # POST /jobs.json
  def admin_create
    param = job_params
    industry = param[:ind]
    param.delete(:ind)
    @job = Job.new(param)
    @job.client = current_client
    @job.industryjob.new(industry:Industry.find_by_id(industry.to_i))
    respond_to do |format|
      if @job.save
        format.html { redirect_to admin_jobs_show_path(@job), notice: 'Job was successfully created.' }
        format.json { render :admin_show, status: :created, location: @job }
      else
        format.html { render :admin_new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def admin_update
    param = job_params
    industry = param[:ind]
    param.delete(:ind)
    @job.industryjob.destroy_all
    @job.industryjob.new(industry:Industry.find_by_id(industry))
    respond_to do |format|
      if @job.update(param)
        format.html { redirect_to admin_jobs_show_path(@job), notice: 'Job was successfully updated.' }
        format.json { render :admin_show, status: :ok, location: @job }
      else
        format.html { render :admin_edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def admin_destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to admin_jobs_url,  notice: 'Job was successfully destroyed.' }
    end
  end

  def admin_extras
    param = params.require(:jobs).permit(:id, :option)
    job = Job.find_by_id(param[:id])
    case param[:option]
      when '1'
        if not job.urgent.nil?
          job.urgent_off
        else
          job.urgent_on
        end
      when '2'
        if not job.top.nil?
          job.top_off
        else
          job.top_on
        end
      when '3'
        if not job.highlight.nil?
          job.highlight_off
        else
          job.highlight_on
        end
    end
    respond_to do |format|
      format.html { redirect_to admin_jobs_show_path(job),  notice: 'Job was successfully destroyed.' }
    end
  end
  private
    def employer!
      if current_client.character != "employer" and current_client.character != "employee"
        redirect_to root_path, alert: "Please register as an employer"
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:title, :location_id, :salarymin, :salarymax, :permanent, :casual, :temp, :contract, :fulltime, :parttime, :flextime, :remote, :description, :company_id, :education_id, :client_id, :career, :ind, :page)
    end

end
