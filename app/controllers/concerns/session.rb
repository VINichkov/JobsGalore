module Session
  def wf(hash={})
    if session[:workflow]
      Rails.logger.debug  "!!!!!!@@ В Сессии присутсвует запись!!!"
      obj = Workflow.find_by_session(session[:workflow])
      yield obj if block_given?
      Rails.logger.debug  "!!!!!!@@ клиент #{hash[:client]&.firstname} #{hash[:client]&.lastname}"
      obj.update_state(hash) if hash[:client]
      obj
    end
  end

  def add_new_workflow(arg = {})
    session[:workflow] = session.id
    Workflow.new(arg)
  end

  def workflow_link(arg)
    Rails.logger.debug  "-->> Link for class #{arg.class.to_s.to_sym}"
    case arg.class.to_s.to_sym
    when :ClientWorkflow
      routs = client_link(arg)
      Rails.logger.debug  "-->> Link to #{routs}"
      routs
    when :ResumeWorkflow
      routs = resume_link(arg)
      Rails.logger.debug  "-->> Link to #{routs}"
      routs
    when :JobWorkflow
      routs = job_link(arg)
      Rails.logger.debug  "-->> Link to #{routs}"
      routs
    else
      Rails.logger.debug  "-->> nil"
      nil
    end
  end

  def client_link(arg)
    switch = LazyHash.new(  new: ->{new_client_session_path},
                            not_company: ->{new_company_path})
    switch[arg.aasm.current_state]
  end

  def job_link(arg)
    switch = LazyHash.new(  new: ->{new_job_path},
                            not_client: ->{new_client_session_path},
                            not_company: ->{new_company_path},
                            not_persisted: ->{jobs_path},
                            final: ->{job_path(arg.job.id)})
    switch[arg.aasm.current_state]
  end

  def resume_link(arg)
    switch = LazyHash.new(  new: ->{new_resume_path},
                            not_client: ->{new_client_session_path},
                            not_persisted: ->{resumes_path},
                            final: ->{resume_path(arg.resume.id)})
     switch[arg.aasm.current_state]
  end
end