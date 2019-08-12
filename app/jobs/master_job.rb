class MasterJob < CrawlerJob
  queue_as :default

  def perform(**args)
    puts args[:site]
    var = Variable.new
    var.value = []
    var.save
    Location.select(:id, :suburb, :state).all.each do |city|
      ConveerGetListJob.perform_later(
          name:city.suburb,
          code:city.id,
          site: args[:site],
          var: var.id)
    end
  end
end
