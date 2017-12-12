class ApplicationDecorator < Draper::Decorator
  # Define methods for all decorated objects.
  # Helpers are accessed through `helpers` (aka `h`). For example:
  #
  #   def percent_amount
  #     h.number_to_percentage object.amount, precision: 2
  #   end
  private
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
end
