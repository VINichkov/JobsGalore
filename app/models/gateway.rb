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
      puts "!!_____Start!!!"
      def_thread
    end

  end


  private
  def def_thread
    puts "!!_____Start2!!!"
    logs = "<p>Started: #{Time.now}</p>"
    begin
      puts "!!_____Start3!!!"
      eval "@gate = #{self.script}.new"
      index = Job.where(company: company, client: client).map do |job|
        {title:job.title, date_end: job.close}
      end
      jobs=@gate.read(index)
      logs += "<p>Found #{jobs.count} jobs</p>"
      puts "<p>Found #{jobs.count} jobs</p>"
      jobs.each do |new_job|
        begin
          logs += "<p>Job is creating: title \"#{new_job[:title]}\" close #{new_job[:close]}</p>"
          new_job[:client] = client
          new_job[:company] = company
          new_job[:location] = location
          job=Job.new(new_job)
          #job.industryjob.new(industry: industry)
          job.save!
        rescue
          puts "<p>Error: Job #{$!}</p>"
          logs += "<p>Error: Job #{$!}</p>"
        end
      end
    rescue
      logs += "<p>Error: #{$!}</p>"
    end
    logs += "<p>Finished: #{Time.now}</p>"
    puts logs
    self.log=logs
    save!
  end

end
