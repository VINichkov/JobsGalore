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

  def markdown_to_keywords (arg)
    markdown_to_text (arg).truncate(300).split(' ').join(', ')
  end

  def markdown_to_text (arg)
    Nokogiri::HTML(RDiscount.new(arg).to_html).text.squish
  end
end
