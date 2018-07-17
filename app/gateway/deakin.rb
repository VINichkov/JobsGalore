class Deakin < Adapter
  def initialize
    @jobs=[]
    agent = Mechanize.new
    @doc = agent.get('https://jobs.deakin.edu.au/psc/HCMP/EMPLOYEE/HRMS/c/HRS_HRAM_FL.HRS_CG_SEARCH_FL.GBL?FOCUS=Applicant&SiteId=1')
    @host = 'https://jobs.deakin.edu.au'
  end

  def read (index = nil)
    index = create_index(index)
    form = @doc.forms.first
    form['ICAction']="NAV_PB$0"
    node = form.submit
    form_node = node.forms.first
    i = 0
    node.css('div[id="win0divHRS_AGNT_RSLT_Igridc$0"] li').each do |job|
      title = job.at_css("span[id=\"SCH_JOB_TITLE$#{i}\"]").content
      posted_date = Date.parse(job.at_css("span[id=\"SCH_OPENED$#{i}\"]").content)
      if posted_date.strftime("%d/%m/%Y")== DateTime.now.strftime("%d/%m/%Y") or posted_date.strftime("%d/%m/%Y")== (DateTime.now-(60*60*24)).strftime("%d/%m/%Y")
        form_node['ICAction'] = "HRS_VIEW_DETAILS$#{i}"
        page = form_node.submit
        full_time = page.at_css('span[id="HRS_SCH_WRK_HRS_FULL_PART_TIME"]').content.include?('Full-Time')
        html = page.at_css('div[id="win0divHRS_SCH_PSTDSC$0"]')
        html.css('div[id="win0divHRS_SCH_WRK_DESCR100$0"]').remove
        html.css('div[id="win0divHRS_SCH_WRK_DESCR100$1"]').remove
        html.css('div[id="win0divHRS_SCH_WRK_DESCR100$2"]').remove
        html.css('img').remove
        close=nil
        html.css('p').each do |p|
          if p.content.scan(/CLOSING DATE:/)&.first
            close = p.content.gsub("CLOSING DATE:",'')
          elsif p.content.scan(/To apply please click Apply button at top of screen/)&.first
            p.content = p.content.gsub("To apply please click Apply button at top of screen","To apply please click Apply link")
          end
        end
        close ? close = Date.parse(close) : nil
        unless index&.include?(close ? title + close.strftime('%d.%m.%Y') : title)
          description = ''
          description +=  html.to_s
          description += "<p><a href=\"http://www.deakin.edu.au/about-deakin/work-at-deakin\">Apply for Job</a></p>"
          @jobs.push({  title: title,
                         close: close,
                         fulltime: full_time,
                         description: html_to_markdown(description)})
        end
      end
      i+=1
    end
    return @jobs
  end



end
