class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def markdown_to_text (arg, truncate=nil)
    if arg
      text = HtmlToPlainText.plain_text(arg).squish
      if truncate
        text= text.truncate(truncate, separator: ' ',omission: '')
      end
    end
  end

end
