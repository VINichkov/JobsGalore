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

  def execute
    logs = "Started: #{Time.now} \r\n"
    begin
      eval "@gate = #{self.script}.new"
      index = Job.where(company: company, client: client).map do |job|
        {title:job.title, date_end: job.close}
      end
      jobs=@gate.read(index)
      logs += "Found #{jobs.count} jobs \r\n"
      jobs.each do |new_job|
        begin
          logs += "Job is creating: title \"#{new_job[:title]}\" close #{new_job[:close]} \r\n"
          new_job[:client] = client
          new_job[:company] = company
          new_job[:location] = location
          job=Job.new(new_job)
          if job.save
            job.industryjob.new(industry: industry)
          end
        rescue
          logs += "Error: Job #{$!} \r\n"
        end
      end
    rescue
      logs += "Error: #{$!} \r\n"
    end
    logs += "Finished: #{Time.now}"
    self.log=logs
    save!
  end


  private
  def def_thread


  end

end
