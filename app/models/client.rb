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

  dragonfly_accessor :photo do
    after_assign do |attachment|
     Rails.logger.debug "Client::attachment attributes "
      # Auto orient all the images - so they will look as they should
     attachment.convert! '-resize 400x -quality 60 -gravity center', 'jpg'
    end
  end

  def self.from_omniauth(auth)
    Rails.logger.debug "Client::from_omniauth #{auth.to_json}"
    local = Location.search((auth.info.location.name.delete("!.,:*&()'`\"’").split(" ").map {|t| t=t+":*"}).join("|")).first
    client = where(provider: auth.provider, uid: auth.uid).or(where(email: auth.info.email)).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.firstname = auth.info.first_name
      user.lastname = auth.info.last_name
      user.token = auth.credentials.token
      user.sources = auth.info.urls.public_profile
      user.location = (local ? local : Location.default)
      user.photo_url = auth.info.image # assuming the user model has an image
      user.character=TypeOfClient::APPLICANT
      user.provider = auth.provider
      user.uid = auth.uid
      user.confirm
    end
    [client, Resume.new(OmniAuth::Strategies::Linkedin.linkedin_to_h(auth))]
  end

  def self.new_with_session(params, session)
    Rails.logger.debug "new_with_session зашли"
    super.tap do |user|
      if data = session["devise.linkedin_data"] && session["devise.linkedin_data"]["extra"]["raw_info"]
        user.provider ||=auth.provider
        user.uid ||=auth.uid
        user.token = auth.credentials.token
        user.sources ||= auth.info.urls.public_profile
        user.photo_url ||= auth.info.image
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

  def add_type(arg)
    arg == TypeOfClient::APPLICANT ?  self.character = TypeOfClient::APPLICANT : self.character = TypeOfClient::EMPLOYER
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

  def to_short_h
    {id:id, firstname:firstname,
     lastname:lastname, email:email,
     phone:phone, password:password,
     photo_uid: photo_uid,
     gender:gender,
     location_id:location_id,
     character:character,
     company_id:company_id}
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

   def validate_workflow(wf = nil)
     if wf && (wf == 'JobWorkflow' and !self.resp?)
       errors.add(:character, :blank, message: TypeOfClient::APPLICANT)
       true
     elsif wf && wf == 'ResumeWorkflow' and self.resp?
       errors.add(:character, :blank, message: TypeOfClient::EMPLOYER)
       true
     end

   end

end
