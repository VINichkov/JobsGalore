class JobDecorator < ApplicationDecorator
  delegate_all

  attr_reader :salary

  def initialize(object, options = {})
    super
    @salary = calc_salary(object)
  end

  private

  def calc_salary(arg)
    if arg.salarymax.blank? and not arg.salarymin.blank? then
      arg.salarymin.to_i.to_s
    elsif not (arg.salarymax.blank? and arg.salarymin.blank? )
      arg.salarymin.to_i.to_s+" - "+ arg.salarymax.to_i.to_s
    elsif not arg.salarymax.blank? and arg.salarymin.blank?
      arg.salarymax.to_i.to_s
    else
      nil
    end
  end
end