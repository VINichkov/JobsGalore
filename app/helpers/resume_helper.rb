module ResumeHelper
  def meta_for_resume(resume)
     meta_head({ description: resume.description_meta,
                  title: resume.title,
                  keywords: resume.keywords,
                  url: resume_url(resume),
                  canonical: resume_url(resume),
                  published: resume.updated_at})
  end
end