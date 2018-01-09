class Unsw < Adapter
  def initialize
    @jobs=[]
    agent = Mechanize.new
    @doc = agent.get('https://applicant.cghrm.unsw.edu.au/psc/hrm/NS_CAREERS/HRMS/c/HRS_HRAM.HRS_APP_SCHJOB.GBL?FOCUS=Applicant&FolderPath=PORTAL_ROOT_OBJECT.HC_HRS_CE_GBL2&IsFolder=false&IgnoreParamTempl=FolderPath%252cIsFolder&PortalActualURL=https%3a%2f%2fapplicant.cghrm.unsw.edu.au%2fpsc%2fhrm%2fNS_CAREERS%2fHRMS%2fc%2fHRS_HRAM.HRS_APP_SCHJOB.GBL%3fFOCUS%3dApplicant&PortalRegistryName=NS_CAREERS&PortalServletURI=https%3a%2f%2fapplicant.cghrm.unsw.edu.au%2fpsp%2fhrm%2f&PortalURI=https%3a%2f%2fapplicant.cghrm.unsw.edu.au%2fpsc%2fhrm%2f&PortalHostNode=PSFT_HR&NoCrumbs=yes&PortalKeyStruct=yes')
  end

  def read (index = nil)
    index = create_index(index)
    form = @doc.forms.first
    @doc.css('table[id="HRS_AGNT_RSLT_I$scroll$0"] tr td[class="PSLEVEL1SSGRIDROW"]').each do |td|
      span = td.css('div [class="attributes PSTEXT align:left"] span')
      unless span.text.empty?
        hash = span.text.split('|').map do |str|
          str.strip.split(':',2).map {|word| "\"#{word.strip}\""}.join('=>')
        end
        eval  "hash = {#{hash.join(', ')}}"
        if hash.class == Hash
          hash["Posted Date"] = Date.parse(hash["Posted Date"]) if hash["Posted Date"]
          hash["Close Date"] = Date.parse(hash["Close Date"]) if hash["Close Date"]
          if hash["Posted Date"].strftime("%d/%m/%Y")== DateTime.now.strftime("%d/%m/%Y") or hash["Posted Date"].strftime("%d/%m/%Y")== (DateTime.now-(60*60*24)).strftime("%d/%m/%Y")
            hash[:title] = td.css('a')&.text
            form['ICAction']= td.css('a')&.first["href"]&.scan(/#ICSetFieldHRS_APP_SCHJOB.HRS_JOB_OPEN_ID_PB\.\d+/)&.first&.to_s
            page = form.submit
            job =  page.css('div[class="PT_RTE_DISPLAYONLY"]')
            job.css('script')&.remove
            job.css('p').each do |e|
              unless (e.content.to_s.scan(/(You should systemically address the selection criteria)/).empty? or e.content.to_s.scan(/(You should systematically address)/).empty? or e.content.to_s.scan(/(Please disable "Pop-up Blockers" )/).empty?)
                e.remove
              else
                if   e.content.to_s.scan(/(Full Time)/).empty?
                  hash[:fulltime] = true
                end
              end
            end
            unless index&.include?(hash["Close Date"] ? hash[:title] + hash["Close Date"].strftime('%d.%m.%Y') : hash[:title])
              description = ''
              description += "<p><strong>Location:</strong> #{hash["Location"]}</p>"
              description += "<p><strong>Department:</strong> #{hash["Department"]}</p>"
              description += "<p><strong>Job Family:</strong> #{hash["Job Family"]}</p>"
              description += "<hr>"
              description += job.to_s
              hash[:description] = html_to_markdown(description)
              @jobs.push ({  title: hash[:title],
                            close: hash["Close Date"],
                            fulltime: hash[:fulltime],
                            description: hash[:description]})
            end
          end
        end
      end
    end
    return @jobs
  end

end
