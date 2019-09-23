class ConveerPrepareJob < CrawlerJob
  queue_as :conveer_prepare_job

  def perform(**args)
    init_class(args[:site]).get_list(args, args[:var])
  end
end