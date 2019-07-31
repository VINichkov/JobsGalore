class IndexController < ApplicationController
  #authorize_resource only:[:admin]
  skip_before_action :verify_authenticity_token, only: [:file_to_html]
  def main
    @main = Main.call(query:@search)
    render 'index/main/main_md' if md?
    render 'index/main/main_xs' unless md?
  end

  def advertising_terms_of_use
  end

  def category_view
    @category_view = CategoryView.call(params:params.permit(:category, :object, :page))
    unless @category_view.success?
      render_404
    end
  end

  def main_search
    @result = MainSearch.call(params:main_search_params)
    a = @result.param.to_h
    cookies[:query] = {value: JSON.generate({ type: a["type"],
                                              value:"",
                                              category: a["category"],
                                              location_id:a["location_id"],
                                              location_name:a["location_name"],
                                              open:false}),
                       expires: 1.year}
    @search = @result.param
    if @result.failure?
      render_404
    end
  end

  def by_category
    @by_category = ByCategory.call(params:params[:obj])
    unless @by_category.success?
      render_404
    end
  end

  def about
  end

  def contact
  end

  def send_mail
    ContactUsMailer.send_mail(params.require(:contact).permit(:firstname, :lastname, :email, :subject, :message, :phone).to_h).deliver_later
    redirect_to(contact_path, notice: 'Email sent')
  end

  def send_to_customers
      Email.all.each do |adress|
        ContactUsMailer.send_to_customers(adress.email).deliver_later
      end
    redirect_to(root_path, notice: "Show must go on!!!")
  end

  def terms_and_conditions
  end

  def privacy
  end

  def admin
  end

  def sitemap
    @max_page_companies = count_page(Company.count)
    @max_page_resumes = count_page(Resume.count)
    @max_page_jobs = count_page(Location.select(:counts_jobs).inject(0){|rez, elem| rez +=elem.counts_jobs if elem.counts_jobs}.to_i)
    render :sitemap, formats: :xml
  end

  def sitemaps
    @objs =[]
        time = Time.now.strftime("%Y-%m-%d")
        case params[:id]
          when '1'
            @objs << {url: root_url, date:time,changefreq:"hourly" }
          when '2'
            Company.select(:id, :updated_at).paginate(page: params[:page], per_page:5000).each do |company|
              @objs <<{url: company_url(company), date:company.updated_at.strftime("%Y-%m-%d"),changefreq:"hourly" }
              @objs <<{url: jobs_at_company_url(company), date: time,changefreq:"hourly" }
            end
          when '3'
            Resume.select(:id, :updated_at).paginate(page: params[:page], per_page:5000).find_each do |resume|
              @objs <<{url: resume_url(resume), date:resume.updated_at.strftime("%Y-%m-%d"),changefreq:"hourly" }
            end
          when '4'
            Job.select(:id, :updated_at).paginate(page: params[:page], per_page:5000).find_each do |job|
              @objs <<{url: job_url(job), date:job.updated_at.strftime("%Y-%m-%d"),changefreq:"hourly" }
            end
          when '5'
            Location.select(:id).find_each do |location|
              @objs <<{url: local_object_url(location.id, Objects::JOBS.code), date:time,changefreq:"hourly" }
              @objs <<{url: local_object_url(location.id, Objects::RESUMES.code), date:time,changefreq:"hourly" }
              @objs <<{url: local_object_url(location.id, Objects::COMPANIES.code), date:time,changefreq:"hourly" }
            end
        end
    render :sitemaps, formats: :xml
  end

  def robot
    respond_to do |format|
      format.txt{render file: 'public/robots.txt'}
      format.html{redirect_to root_url}
    end
  end

  def rss
    t = Time.now
    @obj = Job.select(:id,:title,:company_id, :location_id, :industry_id, :updated_at, :created_at, :description).includes(:company, :industry, :location).where(created_at:t-1.week..t).decorate
    render :rss, formats: :xml
  end

  def file_to_html
    @file = OfficeDocumentToHtml.call(params: params.permit(:file))
    render :file_to_html, formats: :json
  end

  def logo
    send_file 'public/jg.png', type: 'image/png', disposition: 'inline'
  end

  def jg
    send_file 'public/face.jpg', type: 'image/png', disposition: 'inline'
  end

  private

  def main_search_params
    params.permit(:page, main_search: [:type, :value, :page, :salary,  :options, :category, :location_id, :location_name, :urgent, :open, :sort])
  end

  def count_page(count)
    res = count / 5000
    res += 1 if (count % 5000)>0
  end

end
