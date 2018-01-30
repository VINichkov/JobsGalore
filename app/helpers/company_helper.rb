module CompanyHelper

  def company_name (object)
    content_tag :h1, class:"text-center" do
      html = object.name.html_safe
      html += if object.realy?
         content_tag( :span, nil,class: "glyphicon glyphicon-ok")
      end
    end
  end

  def jobs_of_company (object)
    if object.jobs_count>0
       content_tag :div, class:"row" do
         content_tag :h3 do
          link_to "#{object.jobs_count} jobs at #{object.name}", jobs_at_company_path(object)
         end
       end
    end
  end

  def company_summary (object)
    html = ActiveSupport::SafeBuffer.new
    html += if object.site
              content_tag( :p, link_to(object.site, object.site, rel:"nofollow"))
           end
    html +=content_tag(:p) do
      p = content_tag :strong, "Location: "
      p += object.location_full.html_safe
    end
    html +=if object.size
             content_tag(:p) do
               p = content_tag :strong, "Size: "
               p+= "#{object.size.size}".html_safe
             end
           end
    html +=if object.recrutmentagency?
             content_tag(:p) do
               content_tag :strong, "Recruitment agency "
             end
           end
    html +=if object.industries_count>0
             ind = content_tag(:p) do
                  content_tag :strong, "Indusrty: "
             end
             ind +=content_tag( :ul) do
               object.industry.reduce(" "){ |li,industry|
                  li += content_tag(:li ," #{industry.name}")
               }.html_safe

             end
           end
  end

  def buttons( class_name)
    content_tag(:div,class:"row") do
      buttons  = content_tag(:div, class:class_name) do
        div = button_tag "Contact", class: "btn btn-primary btn-block", "data-toggle":"modal", "data-target":"#contact"
        div += content_tag (:p)
      end
      buttons  += content_tag(:div, class:class_name) do
        div = button_tag "Back", class: "btn btn-success btn-block", onclick:"history.back()"
        div += content_tag (:p)
      end
    end
  end



  def company_description
    @company.description_html.html_safe
  end


end
