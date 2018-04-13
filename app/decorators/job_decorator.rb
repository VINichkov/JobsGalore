class JobDecorator < ApplicationDecorator
  delegate_all
  decorates_association :client
  decorates_association :company

  def keywords
    @keywords ||= "Australia, Job, Jobs, Galore, Jobsgalore,#{object.title}, Job in #{object.location.name}, Company is #{object.company.name}, #{markdown_to_keywords(object.description)}"
  end

  def extras(arg)
    swich = {'1'=>:urgent, '2'=> :top, '3'=> :highlight}
    self.turn swich[arg]
  end

  def turn(extra)
    eval ("object.#{extra} ? object.#{extra}_off : object.#{extra}_on")
    true
  end

end