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
    puts "!___#{markdown_to_text(arg, 300).split(' ').to_s}"
    keys = markdown_to_text(arg, 300).split(' ').map do |key|
      key.delete('?!#;\'\",\\|%^&*-_=+~1234567890(){}[]')
      #key = '' unless key&.count>3
    end
    puts puts "!___#{keys}"
    puts puts "!___#{keys.compact}"
    keys.compact.join(', ')
  end

  def markdown_to_text (arg, truncate=nil)
    text = Nokogiri::HTML(RDiscount.new(arg).to_html).text.squish
    if truncate
      text.truncate(truncate, separator: ' ',omission: '')
    end
  end
end
