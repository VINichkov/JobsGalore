module IndexHelper
JOBS = {code:2, name:"Jobs"}
COMPANIES = {code:1, name:"Companies"}
RESUMES = {code:3, name:"Resumes"}

  def last_job(job)
    content_tag(:li ){
      li =content_tag(:hr)
      li+=content_tag(:p, link_to(job.title, job))
      li+=content_tag(:p, link_to(job.company.name, job.company), class: "small")
      li+=content_tag(:p, job.location.state.to_s+" "+job.location.suburb.capitalize.to_s, class: "small")
    }
  end
end
