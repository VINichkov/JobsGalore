class Client < ApplicationRecord

  # Include default devise modules. Others available are:
   #:omniauthable
  before_save :rename, :type

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: %i[linkedin]
  if Rails.env.production?
    devise  :confirmable, :lockable, :timeoutable
  end

  belongs_to :location
  belongs_to :company
  has_many :gateway, dependent: :destroy
  has_many :resume, dependent: :destroy
  has_many :job, dependent: :destroy



  dragonfly_accessor :photo do
    after_assign do |attachment|
      # Auto orient all the images - so they will look as they should
      attachment.convert! '-resize 400x -quality 60 -gravity center', 'jpg'

    end
  end


  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :location, presence: true
  validates :phone, presence: true

  def self.from_omniauth(auth)
    Rails.logger.debug "Client::from_omniauth #{auth.to_json}"
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      Rails.logger.debug "Client::from_omniauth нашли что то #{user.to_json}"
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.firstname = auth.info.name   # assuming the user model has a name
      user.photo = auth.info.image # assuming the user model has an image
      user.character='applicant'
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
    Rails.logger.debug "Client::from_omniauth окончили"
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.linkedin_data"] && session["devise.linkedin_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
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
    (character=='employer')or(character=='employee') ? true : false
  end

  def employer?
    character=='employer' ? true : false
  end

  def change_type
    self.employer? ? self.character='employee' : self.character='employer'
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
      self.character='applicant'
    elsif character == 'on'
      self.character = 'employer'
    end
  end

 def validate_workflow(wf = nil)
   Rails.logger.debug "Client::validate_workflow #{self.to_json}"
   Rails.logger.debug "Client::validate_workflow  wf = #{wf}"
   Rails.logger.debug "Client::validate_workflow  wf == JobWorkflow and !self.resp? #{wf == JobWorkflow and !self.resp?}"
   Rails.logger.debug "Client::validate_workflow  wf == ResumeWorkflow and self.resp? = #{wf == ResumeWorkflow and self.resp?}"
   Rails.logger.debug "Client::validate_workflow  wf != ClientWorkflow = #{wf != ClientWorkflow}"
   if wf && (wf == 'JobWorkflow' and !self.resp?)
     errors.add(:character, :blank, message: "applicant")
     true
   elsif wf && wf == 'ResumeWorkflow' and self.resp?
     errors.add(:character, :blank, message: "employer")
     true
   end

 end

end
