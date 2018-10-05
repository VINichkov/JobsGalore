require 'zip'
class Docx
  attr_reader :paragraphs

  def initialize(path)
    @str = Zip::File.open(path).read('word/document.xml').scan(/(<w:t>.*?<\/w:t>)/).join
  end

  def to_html(const)
    @str[0..const*1.7].gsub("w:t","p").force_encoding(Encoding::UTF_8)
  end

end