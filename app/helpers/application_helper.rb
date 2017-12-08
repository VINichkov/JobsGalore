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
    t = Time.now
    puts "!!__________Зашли в markdown_to_keywords"
    keys = markdown_to_text(arg, 400).split(' ').map do |key|
      key.delete!(',')
      key = nil unless key&.length>3
      key
    end
    puts "!!__________Конец markdown_to_keywords #{Time.now - t}"
    keys.compact.uniq.join(', ')
  end

  def markdown_to_text (arg, truncate=nil)
    t = Time.now
    puts "!!__________Зашли в markdown_to_text"
    text = Nokogiri::HTML(RDiscount.new(arg).to_html).text.squish
    if truncate
      text= text.truncate(truncate, separator: ' ',omission: '')
    end
    puts "!!__________Конец markdown_to_text #{Time.now - t}"
    text
  end
end
