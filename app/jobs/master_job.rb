class MasterJob < CrawlerJob
  queue_as :default

  def perform(*args)
    Location.select(:id, :suburb, :state).all.each{|city| ConveerGetListJob.perform_later(name:city.suburb,code:city.id)}
  end
end
