class ConveerGetListJob < CrawlerJob
  queue_as :conveer_get_list

  def perform(*args)
    puts args
  end
end