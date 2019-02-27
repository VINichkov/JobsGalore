class Client < ApplicationRecord

  before_save :rename, :type

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: %i[linkedin google_oauth2]
  if Rails.env.production? #or 1==1
    devise  :confirmable, :lockable, :timeoutable
  end

  belongs_to :location
  belongs_to :company
  has_many :gateway, dependent: :destroy
  has_many :resume, dependent: :destroy
  has_many :job, dependent: :destroy
  has_many :responded
  has_many :viewed

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :location, presence: true

  dragonfly_accessor :photo #do
  #  after_assign do |attachment|
  #   Rails.logger.info "Client::attachment attributes "
  #   if attachment
  #     Rails.logger.info "Client::dragonfly_accessor не пусто "
  #   end
  #    # Auto orient all the images - so they will look as they should
  #   attachment.convert! '-resize 400x -quality 60 -gravity center', 'jpg'
  #  end
  #end

  def send_email_about_job?
    self.send_email && self.company&.big == false
  end

  def self.from_omniauth(auth)
    Rails.logger.info "Client::from_omniauth #{auth.to_json}"
    if auth.info&.location
      local = Location.search((auth.info.location.name.delete("!.,:*&()'`\"’").split(" ").map {|t| t=t+":*"}).join("|")).first
    else
      local = nil
    end
    sources = (auth.info.urls.public_profile ? auth.info.urls.public_profile : auth.info.urls.google)
    client = where(provider: auth.provider, uid: auth.uid).or(where(email: auth.info.email)).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.firstname = auth.info.first_name
      user.lastname = auth.info.last_name
      user.token = auth.credentials.token
      user.sources = sources
      user.location = (local ? local : Location.default)
      Rails.logger.info "!!!!! Client::from_omniauth картнка по адресу #{auth.info.image}"
      user.photo_url = auth.info.image # assuming the user model has an image
      user.character=TypeOfClient::APPLICANT
      user.provider = auth.provider
      user.uid = auth.uid
      user.skip_confirmation!
    end
    if auth.credentials.token.blank?
      client.update(token: auth.credentials.token, sources: sources)
    end
    [client, Resume.new(LinkedInClient.new.linkedin_to_h(auth))]
  end

  def self.new_with_session(params, session)
    Rails.logger.info "new_with_session зашли"
    super.tap do |user|
      Rails.logger.info "Создали новую сессию"
      if (data = session["devise.linkedin_data"] && session["devise.linkedin_data"]["extra"]["raw_info"]) or (data = session["devise.google_oauth2"] && session["devise.google_oauth2"]["extra"]["raw_info"])
        Rails.logger.info "Обновим все"
        user.provider ||=auth.provider
        user.uid ||=auth.uid
        user.token = auth.credentials.token
        user.sources ||= (auth.info.urls.public_profile ? auth.info.urls.public_profile : auth.info.urls.google)
        user.photo_url ||= auth.info.image
      end
    end
  end
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
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

   def validate_workflow(wf = nil)
     if wf && (wf == 'JobWorkflow' and !self.resp?)
       errors.add(:character, :blank, message: TypeOfClient::APPLICANT)
       true
     elsif wf && wf == 'ResumeWorkflow' and self.resp?
       errors.add(:character, :blank, message: TypeOfClient::EMPLOYER)
       true
     end
   end

  def full_name
    @full_name ||= self.firstname.capitalize+' '+self.lastname.capitalize
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

  def resumes_for_apply
    resume.select(:id, :title, :salary, :description, :location_id, :industry_id).all.includes(:location,:industry).map  do |t|
      {id: t.id,
       title: t.title,
       location: t.location&.name,
       industry: t.industry&.name,
       salary: t.salary,
       description: t.description }
    end
  end

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
