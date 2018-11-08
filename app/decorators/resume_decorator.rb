class ResumeDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
  decorates_association :client
  def keywords
    @keywords ||= "CV, resume online, recrutment, Jobs Galore, Australia, Resumes, Resume, Galore, Jobsgalore,#{object.title}, Talent in #{object.location.name}, Talent, #{markdown_to_keywords(object.title)}"
  end

  def extras(arg)
    swich = {'1'=>:urgent, '2'=> :top, '3'=> :highlight}
    self.turn swich[arg]
  end


  def turn(extra)
    eval ("object.#{extra} ? object.#{extra}_off : object.#{extra}_on")
  end

  def salary
    @salary ||="$"+object.salary.to_i.to_s if object.salary.present? && object.salary!=0
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
      pdf.text object.client.full_name, size: 24, align: :center
      pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 25], :width => pdf.bounds.width, :height => 160) do
        pdf.bounding_box([pdf.bounds.left, pdf.bounds.top], :width => pdf.bounds.width / 2, :height => pdf.bounds.height) do
          url = Rails.env.development? ? 'http://127.0.0.1:3000' + Dragonfly.app.remote_url_for(object.client.photo_uid).to_s : Dragonfly.app.remote_url_for(object.client.photo_uid)
          pdf.image open(url), height: 150
        end
        pdf.bounding_box([pdf.bounds.width / 2 + 10, pdf.bounds.top], :width => pdf.bounds.width / 2 - 10, :height => pdf.bounds.height) do
          summary = "<p><strong>Location: </strong>#{object.location.name}</p>"
          summary += "<p><strong>E-mail: </strong>#{object.client.email}</p>"
          summary += "<p><strong>Phone number: </strong>#{object.client.phone }</p>" if object.client.phone
          summary += "<p><strong>Birthday: </strong>#{object.client.birth&.strftime("%d %B %Y")}</p>" if object.client.birth
          summary += "<p><strong>Salary: </strong>#{salary}</p>" if salary
          pdf.styled_text summary
        end
      end
      pdf.move_down(10)
      pdf.text object.title, size: 20
      pdf.styled_text object.description
    end
    pdf.render
  end

end