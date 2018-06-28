class Client < ApplicationRecord

  # Include default devise modules. Others available are:
   #:omniauthable
  before_save :rename, :type

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: %i[linkedin]
  if Rails.env.production?
    devise  :confirmable, :lockable, :timeoutable
  end

  belongs_to :location
  belongs_to :company
  has_many :gateway, dependent: :destroy
  has_many :resume, dependent: :destroy
  has_many :job, dependent: :destroy

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :location, presence: true

  #dragonfly_accessor :photo do
  #  after_assign do |attachment|
   #   Rails.logger.debug "Client::attachment attributes "
      # Auto orient all the images - so they will look as they should
   #   attachment.convert! '-resize 400x -quality 60 -gravity center', 'jpg'

   # end
  #end


  def self.from_omniauth(auth)
    Rails.logger.debug "Client::from_omniauth #{auth.to_json}"
    where(provider: auth.provider, uid: auth.uid).or(where(email: auth.info.email)).first_or_create do |user|
      Rails.logger.debug "Client::from_omniauth не нашли ничего #{user.to_json}"
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.firstname = auth.info.first_name
      user.lastname = auth.info.last_name
      local = Location.search((auth.info.location.name.delete("!.,:*&()'`\"’").split(" ").map {|t| t=t+":*"}).join("|")).first
      user.location = (local ? local : Location.default)
      user.photo_url = auth.info.image # assuming the user model has an image
      user.character=TypeOfClient::APPLICANT
      user.confirm
      Rails.logger.debug "Client::from_omniauth создали клиента #{user.to_json}"
    end
  end


  def self.new_with_session(params, session)
    Rails.logger.debug "!!!Linkedin:: new_with_session зашли"
    Rails.logger.debug "Linkedin:: полечаем данные пользователя. Из Linkedin  #{session.to_json}"
    super.tap do |user|
      if data = session["devise.linkedin_data"] && session["devise.linkedin_data"]["extra"]["raw_info"]
        Rails.logger.debug "Linkedin:: полечаем данные пользователя. Из Linkedin  #{session["devise.linkedin_data"].to_json}"
        #user.email = data["email"] if user.email.blank?
        user.provider ||=auth.provider
        user.uid ||=auth.uid
      end
    end
  end

  def admin?
    self.email == PropertsHelper::ADMIN
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
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

  def rename()
    return unless self.photo.present?
    begin
      path_obj = Pathname(self.photo.name)
      self.photo.name = path_obj.sub_ext('').to_s.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + path_obj.extname
    rescue
      logger.fatal "Error: #{$!}"
    end
  end

  def full_name
    @full_name ||= self.firstname+' '+self.lastname
  end

  def type
    if self.character.nil?
      self.character=TypeOfClient::APPLICANT
    elsif character == 'on'
      self.character = TypeOfClient::EMPLOYER
    end
  end

 def validate_workflow(wf = nil)
   Rails.logger.debug "Client::validate_workflow #{self.to_json}"
   Rails.logger.debug "Client::validate_workflow  wf = #{wf}"
   Rails.logger.debug "Client::validate_workflow  wf == JobWorkflow and !self.resp? #{wf == JobWorkflow and !self.resp?}"
   Rails.logger.debug "Client::validate_workflow  wf == ResumeWorkflow and self.resp? = #{wf == ResumeWorkflow and self.resp?}"
   Rails.logger.debug "Client::validate_workflow  wf != ClientWorkflow = #{wf != ClientWorkflow}"
   if wf && (wf == 'JobWorkflow' and !self.resp?)
     errors.add(:character, :blank, message: TypeOfClient::APPLICANT)
     true
   elsif wf && wf == 'ResumeWorkflow' and self.resp?
     errors.add(:character, :blank, message: TypeOfClient::EMPLOYER)
     true
   end

 end

end
