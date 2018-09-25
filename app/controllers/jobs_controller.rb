class JobsController < ApplicationController
  load_and_authorize_resource :job
  before_action :set_job, only: [:apply, :views,:highlight_view ,:show, :edit, :update, :destroy, :admin_show, :admin_edit, :admin_update, :admin_destroy]
  before_action :action_view, only:[:show, :highlight_view]
  #before_action :employer!, only: :new

  def show
  end

  def highlight_view
    @query = params[:text].split("/")
  end

  def views
  end

  # GET /jobs/new
  def new
    session[:workflow] = nil
    job_workflow = add_new_workflow(class: :JobWorkflow)
    @job = job_workflow.job.decorate
    job_workflow.save!(session[:workflow])
  end

  # GET /jobs/1/edit
  def edit
  end

  def create_temporary
    job_workflow = wf
    job_workflow.update_state(job:Job.new(job_params), client: current_client)
    job_workflow.save!(session[:workflow])
    respond_to do |format|
      format.html { redirect_to workflow_link(job_workflow)}
    end
  end

  # POST /jobs
  # POST /jobs.json
  def create_job
    job_workflow = wf
    @job = job_workflow.job.decorate
    respond_to do |format|
      if @job.save
        job_workflow.save!(session[:workflow])
        format.html {redirect_to workflow_link(job_workflow) , notice: current_client ?  'Job was successfully created.' : flash[:notice]}
      else
        format.html {render :new}
      end
    end
  end

  def apply
    if @job.apply
      unless current_client&.admin?
        @job.add_responded({user:current_client&.id, company: current_company&.id, time:Time.now, ip:request.remote_ip, lang:request.env['HTTP_ACCEPT_LANGUAGE'], agent:request.env['HTTP_USER_AGENT']})
      end
      redirect_to @job.apply, status:307
    else
      render_404
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to jobs_root_path, notice: 'Job was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_root_path, notice: 'Job was successfully destroyed.' }
    end
  end

  def admin_index
    @not_id = Industryjob.all.map {|t| t.job_id} if @not_id.nil?
    @jobs = Job.where('id not in (?)', @not_id).includes(:location,:company, :client).order(:close).paginate(page: params[:page], per_page:21)
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
    @job.industryjob.new(industry:Industry.find_by_id(industry))
    respond_to do |format|
      if @job.save
        format.html { redirect_to admin_jobs_show_path(@job), notice: 'Job was successfully created.' }
      else
        format.html { render :admin_new }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def admin_update
    param = job_params
    respond_to do |format|
      if @job.update(param)
        format.html { redirect_to admin_jobs_url, notice: 'Job was successfully updated.' }
      else
        format.html { render :admin_edit }
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
    param = job_params
    @job = Job.find_by_id(param[:id]).decorate
    respond_to do |format|
      if @job.extras(param[:option])
        format.html { redirect_to job_path(@job),  notice: 'Done' }
      else
        format.html { redirect_to job_path(@job),  notice: 'Error!!!.' }
      end
    end
  end

  private

    def action_view
      unless current_client&.admin? or current_client == @job.client
        @job.add_viewed({user:current_client&.id, company: current_company&.id, time:Time.now, ip:request.remote_ip, lang:request.env['HTTP_ACCEPT_LANGUAGE'], agent:request.env['HTTP_USER_AGENT']})
      end

    end
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id]).decorate
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:id,:title, :location_id, :salarymin, :salarymax, :description, :company_id, :client_id, :industry_id, :close, :page, :option)
    end

end
