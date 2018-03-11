class JobDecorator < ApplicationDecorator
  delegate_all
  decorates_association :client
  decorates_association :company

  def keywords
    @keywords ? @keywords : @keywords = "Australia, Job, Jobs, Galore, Jobsgalore,#{object.title}, Job in #{object.location.name}, Company is #{object.company.name}, #{markdown_to_keywords(object.description)}"
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