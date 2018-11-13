class SendResume
  include Interactor

  def call
    begin
      resume = create_resume(context.params)
      context.job = Job.find_by_id(context.params[:job])
      send(resume, context.job, context.params[:text])
      context.msg = 'Your resume was successfully sent!'
    rescue
      Rails.logger.debug("ERROR #{$!}")
      context.msg = $!
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
      resume[:client_id] = context.current_client_id
      resume = Resume.create(resume)
      unless resume.persisted?
        raise "We apologize for the inconvenience, but this service is temporarily unavailable."
      end
    else
      resume = Resume.find_by_id(context.params[:resume])
      if resume.blank?
        raise "We apologize for the inconvenience, but this service is temporarily unavailable."
      end
    end
    resume.decorate
  end

  def send(resume, job, letter)
    ResumesMailer.send_to_employer(resume, job, letter).deliver_later
  end
end
