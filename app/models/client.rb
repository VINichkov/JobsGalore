class Client < ApplicationRecord
  # Include default devise modules. Others available are:
   #:omniauthable
  before_save :rename

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  if Rails.env.production?
    devise  :confirmable, :lockable, :timeoutable
  end
  belongs_to :location
  has_many :gateway, dependent: :destroy
  has_many :resume, dependent: :destroy
  has_many :job, dependent: :destroy
  has_many :respons, class_name:"Responsible", dependent: :destroy
  has_many :responsible
  has_many :company, through: :responsible, dependent: :destroy
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




  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def resp?
    (character=='employer')or(character=='employee') ? true : false
  end

  def rename()
    return unless self.photo.present?
    path_obj = Pathname(self.photo.name)
    self.photo.name = path_obj.sub_ext('').to_s.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + path_obj.extname
  end
end
