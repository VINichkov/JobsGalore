class HtmlToPdf
  include Prawn::View

  attr_accessor :res
  def initialize(text)
    @res = split_by_node(text)
    #@pdf  = Prawn::Document.new
  end

  #def from_html(html)
     #html = Nokogiri::HTML(html)

  #end

  #def to_pdf
    #@pdf
  #end

  private

  def split_by_node(text)
    qwer(Nokogiri::HTML(text).at_css("body").children)
  end

  def qwer(html)
      html.map do |elem|
        if html.children.count>1
          {name: elem.name, children: qwer(elem.children)}
        elsif html.children[0].name == "text"
          {name: elem.name, text: elem.text }
        end
      end if html.count>0
  end

end
