module ApplicationHelper

  def title(text)
    content_for :title, text
  end
  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end
  def yield_meta_tag(tag, default_text='')
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end

  #TODO убрать markdown_to_keywords и markdown_to_text когда все будет переделано на презентеры
  def markdown_to_keywords (arg)
    keys = markdown_to_text(arg, 400).split(' ').map do |key|
      key.delete!(',')
      key = nil unless key&.length>3
      key
    end
    keys.compact.uniq.join(', ')
  end

  def markdown_to_text (arg, truncate=nil)
    text = Nokogiri::HTML(RDiscount.new(arg).to_html).text.squish
    if truncate
      text= text.truncate(truncate, separator: ' ',omission: '')
    end
  end

  def meta_head(arg={})
    title arg[:title]
    meta_tag "description",   arg[:description]
    meta_tag "keywords", arg[:keywords]
    meta_tag "og:type", arg[:type] ? arg[:type] : "article"
    meta_tag "og:title", arg[:title]
    meta_tag "og:description", arg[:description]
    meta_tag "og:url", arg[:url]
    meta_tag "og:image", arg[:image]
    meta_tag "article:published_time", arg[:published]
  end

  def render_markdown(text = nil)
    render :inline =>  RDiscount.new(text).to_html.gsub('<img',"<img class=\"img-thumbnail center-block\"") if text
  end
end
