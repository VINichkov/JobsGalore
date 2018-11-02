class ResumeDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
  decorates_association :client
  def keywords
    @keywords ||= "CV, resume online, recrutment, Jobs Galore, Australia, Resumes, Resume, Galore, Jobsgalore,#{object.title}, Talent in #{object.location.name}, Talent, #{markdown_to_keywords(object.title)}"
  end

  def extras(arg)
    swich = {'1'=>:urgent, '2'=> :top, '3'=> :highlight}
    self.turn swich[arg]
  end


  def turn(extra)
    eval ("object.#{extra} ? object.#{extra}_off : object.#{extra}_on")
  end

  def salary
    @salary ||="$"+object.salary.to_i.to_s if object.salary.present? && object.salary!=0
  end

  def full_resume
    html = ""
    html += "<h1>#{client.full_name}</h1>"
    html += h.image_tag(Dragonfly.app.remote_url_for(client.photo_uid))
    html += "<p>#{location.name}</p>"
    html += "<p>#{salary}</p>" if salary
    html += "<h2>#{title}</h2>"
    html += description
  end

end