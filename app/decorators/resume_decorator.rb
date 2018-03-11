class ResumeDecorator < ApplicationDecorator
  delegate_all
  decorates_association :client
  def keywords
    @keywords ? @keywords : @keywords = "Australia, Resumes, Resume, Galore, Jobsgalore,#{object.title}, Talent in #{object.location.name}, Talent, #{markdown_to_keywords(object.title)}"
  end

  def extras(arg)
    case arg
      when '1'
        self.turn :urgent
      when '2'
        self.turn :top
      when '3'
        self.turn :highlight
      else
        return nil
    end
    true
  end


  def turn(extra)
    eval ("object.#{extra} ? object.#{extra}_off : object.#{extra}_on")
  end
end