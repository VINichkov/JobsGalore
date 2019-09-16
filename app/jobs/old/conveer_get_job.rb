class ConveerGetJob < CrawlerJob
  queue_as :conveer_get_job

  def perform(**args)
    init_class(args[:site]).get_job(args)
  end
end