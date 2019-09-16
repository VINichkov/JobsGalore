class ApplicationRecord < ActiveRecord::Base
  extend Dragonfly::Model
  self.abstract_class = true

  def markdown_to_text (arg, truncate=nil)
    if arg
      text = Nokogiri::HTML(arg).text.squish
      if truncate
        text= text.truncate(truncate, separator: ' ',omission: '')
      end
    end
  end

end
