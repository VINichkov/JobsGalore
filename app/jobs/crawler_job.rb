class CrawlerJob < ActiveJob::Base
  def init_class(arg)
    klass = class_eval(arg)
    klass.new
  end
end
