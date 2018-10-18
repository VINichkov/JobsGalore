module TypeClient
  extend ActiveSupport::Concern

  def admin?
    self.email == PropertsHelper::ADMIN
  end

  def resp?
    character==TypeOfClient::EMPLOYER or character==TypeOfClient::EMPLOYEE
  end

  def employer?
    character==TypeOfClient::EMPLOYER
  end

  def employee?
    character==TypeOfClient::EMPLOYEE
  end

  def applicant?
    character==TypeOfClient::APPLICANT
  end

  def change_type
    self.employer? ? self.character=TypeOfClient::EMPLOYEE : self.character=TypeOfClient::EMPLOYER
    self.save
  end

  def add_type(arg)
    arg == TypeOfClient::APPLICANT ?  self.character = TypeOfClient::APPLICANT : self.character = TypeOfClient::EMPLOYER
  end

  def type
    if self.character.nil?
      self.character=TypeOfClient::APPLICANT
    elsif character == 'on'
      self.character = TypeOfClient::EMPLOYER
    end
  end

  def linkedin?
    sources ? true : false
  end

end