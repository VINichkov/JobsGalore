class Deakin < Adapter
  def initialize
    @jobs=[]
    #agent = Mechanize.new
    @doc = agent.get('https://jobs.deakin.edu.au/psc/HCMP/EMPLOYEE/HRMS/c/HRS_HRAM_FL.HRS_CG_SEARCH_FL.GBL?FOCUS=Applicant&SiteId=1')
    @host = 'https://jobs.deakin.edu.au'
  end

  def read (index = nil)
    form = @doc.forms.first
    form['ICAction']="NAV_PB$0"
    node = form.submit
    form_node = node.forms.first
    i, time = 0, Time.now
    node.css('div[id="win0divHRS_AGNT_RSLT_Igridc$0"] li').each do |job|
      begin
        id = job.at_css("span[id=\"HRS_APP_JBSCH_I_HRS_JOB_OPENING_ID$#{i}\"]").content
        unless index.include?(id)
          posted_date = Date.parse(job.at_css("span[id=\"SCH_OPENED$#{i}\"]").content)
          Rails.logger.debug " Обрабатываем работу #{id} от #{posted_date}"
          Rails.logger.debug " Условие #{posted_date < time and posted_date > time - 2.day}, первое #{posted_date < time}, второе #{posted_date > time - 2.day}"
          if posted_date < time and posted_date > time - 2.day
            title = job.at_css("span[id=\"SCH_JOB_TITLE$#{i}\"]").content
            Rails.logger.debug "Заклавие #{title}"
            form_node['ICAction'] = "HRS_VIEW_DETAILS$#{i}"
            page = form_node.submit
            Rails.logger.debug "Страница пуста" if page.blank?
            html = page.at_css('div[id="win0divHRS_SCH_PSTDSC$0"]')
            Rails.logger.debug "Получили документ" if html.present?
            html.css('div[id="win0divHRS_SCH_WRK_DESCR100$0"],div[id="win0divHRS_SCH_WRK_DESCR100$1"],div[id="win0divHRS_SCH_WRK_DESCR100$2"],img').remove
            Rails.logger.debug "Удалили лишнее"
            close = nil
            html.css('p').each do |p|
              if p.content.scan(/CLOSING DATE:/)&.first
                close = Date.parse(p.content.gsub("CLOSING DATE:",''))
              end
            end
            Rails.logger.debug "Дата закрытия #{close}"
            @jobs.push({sources: id,
                            apply: "http://www.deakin.edu.au/about-deakin/work-at-deakin",
                            title: title,
                            close: close,
                            description: html_to_markdown(html.to_s)})
          end
        end
        i+=1
      rescue StandardError => e
        @log.push "Error: #{e}"
      end
    end
    return @jobs
  end

  def index(index)
    index&.map { |elem| elem[:title].to_s}
  end

end
