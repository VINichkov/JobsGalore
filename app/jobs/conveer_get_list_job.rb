class ConveerGetListJob < CrawlerJob
  queue_as :conveer_get_list

  def perform(**args)
    init_class(args[:site]).get_main_page(args, args[:var])
  end
end