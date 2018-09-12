class Gateway < ApplicationRecord
  includes Monash
  belongs_to :company
  belongs_to :client
  belongs_to :location
  belongs_to :industry

  validates :company, presence: true
  validates :client, presence: true
  validates :industry, presence: true
  validates :location, presence: true
  validates :script, presence: true

  def execute_getway
    @tread = Thread.new do
      def_thread
    end

  end

  def execute
    def_thread
  end

  private
  def def_thread
    logs = "<p>Started: #{Time.now}</p>"
    begin
      eval "@gate = #{self.script}.new"
      ind = Industry.find_by_name('Other')
      index = Job.where(company: company, client: client).map do |job|
        if company.name == "Deakin University"
          job.sources
        else
          {title:job.title, date_end: job.close}
        end
      end
      jobs=@gate.read(index)
      logs += "<p>Found #{jobs.count} jobs</p>"
      jobs.each do |new_job|
        begin
          logs += "<p>Job created: title \"#{new_job[:title]}\" close #{new_job[:close]}</p>"
          new_job[:client] = client
          new_job[:company] = company
          new_job[:location] = location
          job=Job.new(new_job)
          job.industry = ind
          job.save!
        rescue
          logs += "<p>Error: Job #{$!}</p>"
        end
      end
    rescue
      logs += "<p>Error: #{$!}</p>"
    end
    logs += "<p>Finished: #{Time.now}</p>"
    self.log=logs + @gate.log
    save!
  end

end
