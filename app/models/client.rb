class Client < ApplicationRecord

  # Include default devise modules. Others available are:
   #:omniauthable
  before_save :rename, :type

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
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

  def log
    Rails.logger.debug "Зашли"
  end

end
