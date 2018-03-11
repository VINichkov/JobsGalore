class ApplicationDecorator < Draper::Decorator

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def description_meta
    @description_meta ? @description_meta : @description_meta = markdown_to_text(object.description, 300)
  end

  def description_text
    @description_text ? @description_text : @description_text = markdown_to_text(object.description, 300)
  end

  def description_html
    (@description_html ? @description_html : @description_html = RDiscount.new(object.description).to_html) if object.description
  end

  def render_description
    (@render_description ? @render_description : @render_description = self.description_html.gsub('<img',"<img class=\"img-thumbnail center-block\"").gsub('<a',"<a rel=\"nofollow\"").html_safe) if self.description_html
  end

  def posted_date
    @date ? @date : @date = object.created_at.strftime("%d %B %Y")
  end

  private
  def markdown_to_keywords (arg)
    if arg
      keys = markdown_to_text(arg, 400).split(' ').map do |key|
        key.delete!(',')
        key = nil unless key&.length>3
        key
      end
      keys.compact.uniq.join(', ')
    end
  end

  def markdown_to_text (arg, truncate=nil)
    if arg
      text = Nokogiri::HTML(RDiscount.new(arg).to_html).text.squish
      if truncate
        text= text.truncate(truncate, separator: ' ',omission: '')
      end
    end
  end

end
