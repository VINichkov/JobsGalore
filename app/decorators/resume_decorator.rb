class ResumeDecorator < ApplicationDecorator
  delegate_all
  decorates_association :client
  def keywords
    @keywords ||= "Jobs Galore, Australia, Resumes, Resume, Galore, Jobsgalore,#{object.title}, Talent in #{object.location.name}, Talent, #{markdown_to_keywords(object.title)}"
  end

  def extras(arg)
    swich = {'1'=>:urgent, '2'=> :top, '3'=> :highlight}
    self.turn swich[arg]
  end


  def turn(extra)
    eval ("object.#{extra} ? object.#{extra}_off : object.#{extra}_on")
  end

  def salary
    object.salary.to_i.to_s
  end
end