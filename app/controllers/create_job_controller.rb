class CreateJobController < ApplicationController

  def new
    @job = CreateJob.new()
  end

  def create
    @job = CreateJob.new(job_params)
    respond_to do |format|
      if @job.save(current_client)
        format.html { redirect_to @job }
      else
        format.html { render :new}
      end
    end
  end

  private

  def job_params
    params.require(:create_job).permit(:email, :phone, :location_id, :location_name, :title, :salarymin, :salarymax, :description, :password, :company_name)
  end

end