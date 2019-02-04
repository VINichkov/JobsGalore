class Resume < ApplicationRecord
  serialize :preferences, Hash

  belongs_to :client
  belongs_to :location
  belongs_to :industry
  has_many :viewed, as: :doc, dependent: :destroy

  validates :title, presence: true
  validates :location, presence: true

  attr_accessor :ind, :location_name

  alias_attribute  :description,:abouteme
  alias_attribute  :title,:desiredjobtitle
  alias_attribute :salary_form, :salary

  after_create :send_email

  def full_keywords(count_keys=1 , min_length_word=4)
    if self.title
      array_keywords = []
      array_keywords = self.title&.gsub(/[^[:word:]]/,' ')&.downcase&.split(' ')*5
      array_keywords += self.description&.gsub(/[^[:word:]]/,' ')&.downcase&.split(' ') if self.description
      array_keywords.compact!
      index_hash = {}
      array_keywords.each do |word|
        if word.length>min_length_word
          index_hash[word] ?  index_hash[word] +=1 : index_hash[word]=1
        end
      end
      array_keywords = []
      index_hash.each do |key, value|
        array_keywords << {key => value}
      end
      array_keywords.sort{|x, y| y.values[0]<=> x.values[0]}[0..count_keys-1].map{|t| t.keys.first}
    end
  end

  def add_viewed(arg = {})
    unless Viewed.fit(arg)
      viewed.create!(arg)
      self.viewed_count ? self.viewed_count += 1 : self.viewed_count=1
      save!
    end
  end

  def save
    if self.industry.nil?
      self.industry=Industry.find_by_name('Other')
    end
    super
  end

  def highlight_on
    self.highlight = Date.today
    self.save
  end
  def urgent_on
    self.urgent = Date.today
    self.save
  end
  def top_on
    self.top = Date.today
    self.save
  end
  def highlight_off
    self.highlight = nil
    self.save
  end
  def urgent_off
    self.urgent = nil
    self.save
  end
  def top_off
    self.top = nil
    self.save
  end

  def to_short_h
    {id:id, desiredjobtitle: desiredjobtitle, salary: salary, abouteme:abouteme, client_id:client_id, location_id:location_id, industry_id:industry_id}
  end

  def to_pdf
    pdf = Prawn::Document.new
    pdf.font_families.update(
        "OpenSans" => {normal: "#{Rails.root.join("vendor/assets/fonts/OpenSans-Regular.ttf")}",
                       :bold => "#{Rails.root.join("vendor/assets/fonts/OpenSans-Bold.ttf")}",
                       :italic => "#{Rails.root.join("vendor/assets/fonts/OpenSans-Italic.ttf")}",
                       :bold_italic => "#{Rails.root.join("vendor/assets/fonts/OpenSans-BoldItalic.ttf")}"})
    pdf.font 'OpenSans'
    logo = Rails.root.join("app/assets/images/jg.png")
    pdf.repeat :all, :dynamic => true do
      # header
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], :width => pdf.bounds.width do
        pdf.image logo, height: 25
        pdf.stroke_color "b0b0b0"
        pdf.stroke_horizontal_rule
      end

      # footer
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 25], :width => pdf.bounds.width do
        pdf.text "Page #{pdf.page_number} of #{pdf.page_count}", align: :center, size: 13, color: "b0b0b0"
      end
    end
    #body
    pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 50], :width => pdf.bounds.width, :height => pdf.bounds.height - 100) do
      pdf.text client.full_name, size: 24, align: :center
      pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 25], :width => pdf.bounds.width, :height => 160) do
        pdf.bounding_box([pdf.bounds.left, pdf.bounds.top], :width => pdf.bounds.width / 2, :height => pdf.bounds.height) do
          if  client.photo_uid
            url = Rails.env.development? ? 'http://127.0.0.1:3000' + Dragonfly.app.remote_url_for(client.photo_uid).to_s : Dragonfly.app.remote_url_for(client.photo_uid)
            pdf.image open(url), height: 150
          else
            pdf.image Rails.root.join("app/assets/images/avatar.jpg"), height: 150
          end
        end
        pdf.bounding_box([pdf.bounds.width / 2 + 10, pdf.bounds.top], :width => pdf.bounds.width / 2 - 10, :height => pdf.bounds.height) do
          summary = "<p><strong>Location: </strong>#{location.name}</p>"
          summary += "<p><strong>E-mail: </strong>#{client.email}</p>"
          summary += "<p><strong>Phone number: </strong>#{client.phone }</p>" if client.phone
          summary += "<p><strong>Birthday: </strong>#{client.birth&.strftime("%d %B %Y")}</p>" if client.birth
          summary += "<p><strong>Desired Salary: </strong>$#{salary.to_i.to_s}</p>" if salary
          pdf.styled_text summary
        end
      end
      pdf.move_down(10)
      pdf.text title, size: 20
      pdf.styled_text description
    end
    pdf.render
  end

  def key
    key_words =  self.fts.split(' ').map{|t| t.split(":")}
    key_words.map do |t|
      if t[1]=~/A/
        {t[0].delete("'")=>t[1].count(',')+6}
      else
        {t[0].delete("'")=>t[1].count(',')+1}
      end
    end.sort{|x, y| y.values[0]<=> x.values[0]}[0..2].map{|t| t.keys.first}.join(' ')
  end
  protected

  def send_email
    if self.client.send_email?
      ResumesMailer.add_resume({mail: self.client.email, firstname: self.client.full_name, id: self.id, title: self.title}).deliver_later
    end
  end

  scope :search, ->(query) do
    query = query.to_h if query.class != Hash
    text_query=[]

    text_query << "industry_id = :category" if  query[:category].present?
    text_query << "urgent is not null"  if query[:urgent].present?

    if query[:location_id].present?
      text_query << "location_id = :location_id"
    elsif query[:location_name].present?
      locations = Location.search((query[:location_name].split(" ").map {|t| t=t+":*"}).join("|"))
      text_query << "location_id in "+locations.ids.to_s.sub("[","(").sub("]",")") if locations.present?
    end

    text_query<< "fts @@ to_tsquery(:value)" if query[:value] != ""
    if query[:salary].present?
      query[:salary] = query[:salary].to_i
      text_query << '(salary <= :salary or salary is NULL)'
    end

    text_query = text_query.join(" and ")

    select(:id, :desiredjobtitle, :location_id, :salary_form, :abouteme, :created_at, :updated_at, :highlight,:top,:urgent,:client_id,:industry_id, "ts_rank_cd(fts,  plainto_tsquery('#{query[:value]}')) AS \"rank\"", :viewed_count).where(text_query,query)
  end
end
