require 'concerns/clients/clietnDTO'
require 'concerns/clients/omniauth'
require 'concerns/clients/type_client'

class Client < ApplicationRecord
  include ClientDTO
  include Omniauth
  include TypeClient

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

end
