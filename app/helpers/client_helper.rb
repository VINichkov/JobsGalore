module ClientHelper
  def select_gender(object)
    content_tag :select, class:"text-center col"  do
      html = object.name.html_safe
      html += if object.realy?
                content_tag( :span, nil,class: "glyphicon glyphicon-ok")
              end
    end
  end
end