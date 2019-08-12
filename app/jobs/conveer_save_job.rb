class ConveerSaveJob < CrawlerJob
  queue_as :conveer_save_job

  def perform(**args)
    init_class(args[:site]).create_jobs(args)
  end
end