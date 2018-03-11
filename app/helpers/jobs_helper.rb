module JobsHelper
  def salary(object_name, method, options = {})
    options[:type] = 'number'
    content_tag :div, class: "input-group" do
      html = content_tag :span, "$",class: "input-group-addon"
      html += object_name.text_field method, options
    end
  end


  def company(object)
    html = content_tag(:h4, class: "text-center"){
      link_to(object.name,object)
    }
    html+= image_bg(object.logo_url, "300px", "300px", "250px" )
  end

  def last_job(job)
    content_tag(:li ) {
      li =content_tag(:hr)
      li+=content_tag(:p, link_to(job.title, job))
      li+=content_tag(:p, link_to(job.company.name, job.company, class: 'text-success'), class: "small")
      li+=content_tag(:p, job.location.state.to_s+" "+job.location.suburb.capitalize.to_s, class: "small")
    }
  end


#TODO убрать. Используем партиалы
  def list_job(arg)
    content_tag(:div, class: "col-lg-8 col-md-8" ) do
      arg.map do |job|
        content_tag(:div, class: "panel panel-default"){
          content_tag(:div, class: "row"){
            if job.highlight and job.urgent
              content_tag(:div, view_job(job.decorate), class: "panel-body highlight urgent")
            elsif not (job.highlight) and job.urgent
              content_tag(:div, view_job(job.decorate), class: "panel-body urgent ")
            elsif job.highlight and not (job.urgent)
              content_tag(:div, view_job(job.decorate), class: "panel-body highlight")
            else
              content_tag(:div, view_job(job.decorate), class: "panel-body")
            end
          }
        }
      end.join.html_safe

    end
  end
  def view_job(arg)
    job= content_tag(:div, class:"col-lg-10 col-md-10 col-sm-10 col-xs-12"){
      div = content_tag(:h3, link_to(arg.title_capitalize, arg, class: 'text-warning'))
      div += content_tag(:p, arg.salary) if arg.salary
      div += HTML_Truncator.truncate(render_markdown(arg.description),15 ).html_safe  if arg.description
      div += link_to(' more...', arg)
      div += content_tag(:p)
      div += link_to arg.company.name, arg.company, class: 'text-success'
      div += content_tag(:p, arg.location.name)
    }
    job += content_tag(:div,title_job(arg), class:"col-lg-2 col-md-2 col-sm-2 hidden-xs")
  end

  def title_job(job)
    content_tag(:div , class:"row") {
      row = content_tag(:div, class: "row text-center"){
        link_to(job.company.name.truncate(50, separator: " "), job.company)
      }
      row+= content_tag(:div, class: "row"){
        link_to(image_tag(job.company.logo_url, class: 'img-thumbnail center-block ', size:"270x270", alt:job.company.name), job.company)
      }
      row+= content_tag(:div, class: "row text-center"){
        content_tag(:p, "Posted: "+job.posted_date)
      }
    }
  end

end
