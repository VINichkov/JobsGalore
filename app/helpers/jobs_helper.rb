module JobsHelper
  def salary(object_name, method, options = {})
    options[:type] = 'number'
    content_tag :div, class: "input-group" do
      html = content_tag :span, "$",class: "input-group-addon"
      html += object_name.text_field method, options
    end
  end


  def company_in_jobs(object)
    html = content_tag(:h4, class: "text-center", itemprop:"name"){
      link_to(object.name,object)
    }
    html+= content_tag(:span,object.logo_url, class: "hidden-xs hidden-md hidden-lg hidden-sm",itemprop:"image" )
    html+= image_bg(object.logo_url, "300px", "300px", "250px" )
  end

  def last_job(job)
    content_tag(:li ) {
      li =content_tag(:hr)
      li+=content_tag(:p, link_to(job.title, job))
      li+=content_tag(:p, job.description_text + "...")
      li+=content_tag(:span, link_to(job.company.name, job.company, class: 'text-success'), class: "small")
      li+="&nbsp; - &nbsp;".html_safe
      li+=content_tag(:span, link_location(job.location.name, job.location, Objects::JOBS, class: 'text-warning'), class: "small")
    }
  end

end
