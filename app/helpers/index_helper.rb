module IndexHelper
JOBS = {code:2, name:"Jobs"}
COMPANIES = {code:1, name:"Companies"}
RESUMES = {code:3, name:"Resumes"}

  def last_job(job)
    job_tag = content_tag(:div, class: "col-lg-2 col-md-2"){
      image_tag(@company.logo_url, class: 'img-thumbnail center-block', size:"75x75")
    }
    job_tag+=content_tag(:div, class: "col-lg-10 col-md-10"){
      content_tag(:li ){
        li =content_tag(:hr)
        li+=content_tag(:p, link_to(job.title, job))
        li+=content_tag(:p, link_to(job.company.name, job.company, class: 'text-success'), class: "small")
        li+=content_tag(:p, job.location.state.to_s+" "+job.location.suburb.capitalize.to_s, class: "small")
      }
    }
  end

  def list_job(arg)
    content_tag(:div, class: "col-lg-8 col-md-8" ){
      arg.map do |job|
        if job.highlight.nil? and job.urgent.nil?
          content_tag(:div, view_job(job), class: "panel-body")
        elsif not (job.highlight.nil?) and job.urgent.nil?
          content_tag(:div, view_job(job), class: "panel-body highlight")
        elsif job.highlight.nil? and not (job.urgent.nil?)
          content_tag(:div, view_job(job), class: "panel-body urgent")
        elsif not (job.highlight.nil?) and not (job.urgent.nil?)
          content_tag(:div, view_job(job), class: "panel-body highlight urgent")
        end
      end
    }
  end
  def view_job(arg)
    t = Time.now
    job_title = title_job (arg)
    job = content_tag(:div, class:"col-xs-12 hidden-lg hidden-md hidden-sm"){
      job_title
    }
    job+= content_tag(:div, class:"col-lg-10 col-md-10 col-sm-10 col-xs-12"){
      div = content_tag(:h3, link_to(arg.title.capitalize, arg, class: 'text-warning'))
      div += content_tag(:p, arg.salary) if arg.salary
      div += HTML_Truncator.truncate(RDiscount.new(arg.description).to_html.gsub('<img',"<img class=\"img-thumbnail center-block\" "),30 ).html_safe  if arg.description
      div += link_to(' more...', arg)
      div += content_tag(:p)
      div += link_to arg.company.name, arg.company, class: 'text-success'
      div += content_tag(:p, arg.location.state.to_s+" "+arg.location.suburb.capitalize.to_s)
    }
    job += content_tag(:div, class:"col-lg-2 col-md-2 col-sm-2 hidden-xs"){
      job_title
    }
    job
  end

  def title_job(job)
    content_tag(:div , class:"row") {
      row = content_tag(:div, class: "row text-center"){
        link_to(job.company.name.truncate(50, separator: " "), job.company)
      }
      row+= content_tag(:div, class: "row"){
        url_logo = job.company.logo_uid ? Dragonfly.app.remote_url_for(job.company.logo_uid) : image_url("company_profile.jpg")
        link_to(image_tag(url_logo, class: 'img-thumbnail center-block ', size:"270x270", alt:job.company.name), job.company)
      }
      row+= content_tag(:div, class: "row text-center"){
        content_tag(:p, "Posted: "+job.created_at.strftime("%d %B %Y").to_s)
      }
    }
  end

end
