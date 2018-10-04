class OfficeDocumentToHtml
  include Interactor
  COUNT = 18000
  def call
    begin
      file = context.params[:file]
      document = LazyHash.new("application/pdf"=>->{pdf(file.to_io)},  "application/vnd.openxmlformats-officedocument.wordprocessingml.document"=>->{docx(file.to_io)})
      context.result = {description: context.html=document[file.content_type]}
    rescue
      Rails.logger.info("Error PDF: #{$!}")
      context.result = {description:nil}
    end
  end

  private

  def pdf(file)
    t = Time.now
    i = 0
    a = PDF::Reader.new(file).pages.map do |page|
      page.text.split("\n").compact.map do |str|
        i +=str.count
        "<p>#{str}</p>"
      end
      break if i>=COUNT
    end.join
    puts "Время выполнения: #{(Time.now - t)*1000} ms"
    a
  end

  def doc(file)
    File.open(file) do |f|
      puts f.read
    end
    nil
  end

  def docx(file)
    t = Time.now
    doc = Docx::Document.open(file)
    a=doc.paragraphs.map do |p|
      p.to_html
    end.join
    puts a
    puts "Время выполнения: #{(Time.now - t)*1000} ms"
    a
  end

  def clean_html(html)
    Nokogiri::HTML(html).at_css('body').children.to_s
  end

end