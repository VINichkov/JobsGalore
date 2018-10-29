class SendResume
  include Interactor

  def call
    begin
      resume = create_resume(context.params)
      send(resume, Job.find_by_id(context.params[:job]), context.params[:text])
    rescue
      context.fail!
    end
  end

  private


  def create_resume(arg)
    if arg[:resume] == "New resume"
      resume = arg[:new_resume]
      resume[:industry_id] = resume[:category]
      resume.delete(:category)
      resume.delete(:location_name)
      resume[:client_id] = current_client.id
      resume = Resume.create(resume)
      unless resume.persisted?
        raise "We apologize for the inconvenience, but this service is temporarily unavailable."
      end
    else
      resume = Resume.find_by_id(context.params[:new_resume])
      if resume.blank?
        raise "We apologize for the inconvenience, but this service is temporarily unavailable."
      end
    end
  end

  def send(resume, job, letter)
    ResumesMailer.send_to_employer(resume, job, letter).deliver_later
  end
end
